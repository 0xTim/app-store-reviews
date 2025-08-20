import Vapor
import Queues

// A job that runs on a schedule to fetch reviews from the iTunes API for a specific app.
struct FetchReviewsJob: AsyncScheduledJob {
    let appID: String

    func run(context: QueueContext) async throws {
        let reviewRepository = FluentReviewRepository(database: context.application.db, logger: context.logger)
        let appDataRepository = FluentAppDataRepository(database: context.application.db)
        try await getLatestReviews(client: context.application.client, logger: context.logger, reviewRepository: reviewRepository, appDataRepository: appDataRepository)
    }

    // Main logic for the job. Split out to allow for testing
    func getLatestReviews(client: any Client, logger: Logger, reviewRepository: any ReviewRepository, appDataRepository: any AppDataRepository) async throws {
        let lastUpdated = try await appDataRepository.getLastScrapedDate(appId: appID)

        // Recursively fetch reviews until we have all of them, break out if the review date is older than the last updated date
        var nextLink = "https://itunes.apple.com/us/rss/customerreviews/id=\(appID)/sortBy=mostRecent/page=1/json"
        var currentLink: String? = nil
        var reviews: [Entry] = []
        var olderReviewsToScrape = true

        while nextLink != currentLink, olderReviewsToScrape {
            let response = try await getReviewsFromAPI(url: nextLink, client: client, logger: logger)
            reviews.append(contentsOf: response.feed.entry)

            guard let newCurrentLink = response.feed.link.first(where: { $0.attributes.rel == "self" })?.attributes.href,  let newNextLink = response.feed.link.first(where: { $0.attributes.rel == "next" })?.attributes.href else {
                // This shouldn't happen so bail out
                logger.error("No self or next link found in response", metadata: ["appID": "\(appID)"])
                throw Abort(.internalServerError, reason: "No self or next link found in response")
            }

            // The reviews API returns XML even when requesting JSON, so fix the URLs and strip off any query parameters
            guard var currentLinkComponents = URLComponents(string: newCurrentLink) else {
                logger.error("Failed to parse current link URL", metadata: ["currentLink": "\(newCurrentLink)"])
                throw Abort(.internalServerError, reason: "Failed to parse current link URL")
            }
            currentLinkComponents.queryItems = nil
            currentLinkComponents.path = currentLinkComponents.path.replacingOccurrences(of: "xml", with: "json")
            currentLink = currentLinkComponents.string!

            guard var nextLinkComponents = URLComponents(string: newNextLink) else {
                logger.error("Failed to parse next link URL", metadata: ["nextLink": "\(newNextLink)"])
                throw Abort(.internalServerError, reason: "Failed to parse next link URL")
            }
            nextLinkComponents.queryItems = nil
            nextLinkComponents.path = nextLinkComponents.path.replacingOccurrences(of: "xml", with: "json")
            nextLink = nextLinkComponents.string!

            if let lastUpdated, let lastReview = reviews.last, lastReview.updated >= lastUpdated {
                olderReviewsToScrape = false
            }
        }

        // Get the reviews and ignore any that we would have already scraped
        let filteredReviews = reviews.sorted {
            $0.updated > $1.updated
        }.filter {
            if let lastUpdated {
                return $0.updated > lastUpdated
            } else {
                return true
            }
        }

        for review in filteredReviews {
            let reviewModel = Review(id: review.id, content: review.content.label, score: review.rating, reviewDate: review.updated, author: review.author.name, reviewLink: review.link.attributes.href, appID: self.appID)
            try await reviewRepository.save(reviewModel)
        }

        // Update the last scraped date for this app for the next job run
        try await appDataRepository.saveLastScrapedDate(appId: appID, date: Date())
    }

    func getReviewsFromAPI(url: String, client: any Client, logger: Logger) async throws -> FeedResponse {
        let response = try await client.get(URI(string: url))
        guard response.status == .ok else {
            logger.error(
                "Failed to fetch reviews from iTunes",
                metadata: [
                    "appID": "\(appID)",
                    "status": "\(response.status)",
                    "body": "\(response.body?.description ?? "nil")",
                    "url": "\(url)"
                ])
            throw Abort(.internalServerError, reason: "Failed to fetch reviews from iTunes")
        }
        return try response.content.decode(FeedResponse.self, as: .json)
    }
}
