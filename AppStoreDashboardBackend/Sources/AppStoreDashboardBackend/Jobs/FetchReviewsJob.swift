import Vapor
import Queues

struct FetchReviewsJob: AsyncScheduledJob {
    let appID: String

    func run(context: QueueContext) async throws {
        let repository = FluentReviewRepository(database: context.application.db, logger: context.logger)
        try await getLatestReviews(client: context.application.client, logger: context.logger, repository: repository)
    }

    func getLatestReviews(client: any Client, logger: Logger, repository: any ReviewRepository) async throws {
        let url = "https://itunes.apple.com/us/rss/customerreviews/id=\(appID)/sortBy=mostRecent/page=1/json"
        let response = try await client.get(URI(string: url))
        guard response.status == .ok else {
            logger.error("Failed to fetch reviews from iTunes", metadata: ["appID": "\(appID)", "status": "\(response.status)", "body": "\(response.body?.description ?? "nil")"])
            throw Abort(.internalServerError, reason: "Failed to fetch reviews from iTunes")
        }
        // Need to handle next pages of ratings I don't have
        // Need to handle pagination if there are more reviews than the first page
        let reviews = try response.content.decode(FeedResponse.self, as: .json)
        for review in reviews.feed.entry {
            guard let id = Int(review.id.label) else {
                logger.warning("Could not convert review ID to Int", metadata: ["reviewID": "\(review.id.label)"])
                continue
            }
            guard let score = Int(review.rating.label) else {
                logger.warning("Could not convert review rating to Int", metadata: ["reviewRating": "\(review.rating.label)", "reviewID": "\(review.id.label)"])
                continue
            }
            guard let date = ISO8601DateFormatter().date(from: review.updated.label) else {
                logger.warning("Could not convert review date from ISO8601", metadata: ["reviewDate": "\(review.updated.label)", "reviewID": "\(review.id.label)"])
                continue
            }
            let reviewModel = Review(id: id, content: review.content.label, score: score, reviewDate: date, author: review.author.name.label, reviewLink: review.link.attributes.href)
            try await repository.save(reviewModel)
        }
    }
}
