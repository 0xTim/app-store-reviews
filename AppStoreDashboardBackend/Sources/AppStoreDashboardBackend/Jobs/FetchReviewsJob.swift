import Vapor
import Queues

struct FetchReviewsJob: AsyncScheduledJob {
    let appID: String

    func run(context: QueueContext) async throws {
        let reviewRepository = FluentReviewRepository(database: context.application.db, logger: context.logger)
        let appDataRepository = FluentAppDataRepository(database: context.application.db)
        try await getLatestReviews(client: context.application.client, logger: context.logger, reviewRepository: reviewRepository, appDataRepository: appDataRepository)
    }

    func getLatestReviews(client: any Client, logger: Logger, reviewRepository: any ReviewRepository, appDataRepository: any AppDataRepository) async throws {
        let url = "https://itunes.apple.com/us/rss/customerreviews/id=\(appID)/sortBy=mostRecent/page=1/json"
        let response = try await client.get(URI(string: url))
        guard response.status == .ok else {
            logger.error("Failed to fetch reviews from iTunes", metadata: ["appID": "\(appID)", "status": "\(response.status)", "body": "\(response.body?.description ?? "nil")"])
            throw Abort(.internalServerError, reason: "Failed to fetch reviews from iTunes")
        }

        let lastUpdated = try await appDataRepository.getLastScrapedDate(appId: appID)
        // Need to handle pagination if there are more reviews than the first page
        let reviews = try response.content.decode(FeedResponse.self, as: .json).feed.entry.sorted {
            $0.updated > $1.updated
        }.filter {
            if let lastUpdated {
                return $0.updated > lastUpdated
            } else {
                return true
            }
        }

        for review in reviews {
            let reviewModel = Review(id: review.id, content: review.content.label, score: review.rating, reviewDate: review.updated, author: review.author.name, reviewLink: review.link.attributes.href, appID: self.appID)
            try await reviewRepository.save(reviewModel)
        }

        try await appDataRepository.saveLastScrapedDate(appId: appID, date: Date())
    }
}
