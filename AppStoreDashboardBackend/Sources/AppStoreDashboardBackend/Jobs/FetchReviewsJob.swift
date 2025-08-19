import Vapor
import Queues

struct FetchReviewsJob: AsyncScheduledJob {
    let appID: String

    func run(context: QueueContext) async throws {

    }

    func getLatestReviews(client: any Client, logger: Logger) async throws {
        let url = "https://itunes.apple.com/us/rss/customerreviews/id=\(appID)/sortBy=mostRecent/page=1/json"
        let response = try await client.get(URI(string: url))
        guard response.status == .ok else {
            logger.error("Failed to fetch reviews from iTunes", metadata: ["appID": "\(appID)", "status": "\(response.status)", "body": "\(response.body?.description ?? "nil")"])
            throw Abort(.internalServerError, reason: "Failed to fetch reviews from iTunes")
        }
        // Need to handle next pages of ratings I don't have
        let reviews = try response.content.decode(FeedResponse.self)
        for review in reviews.feed.entry {

        }
    }
}
