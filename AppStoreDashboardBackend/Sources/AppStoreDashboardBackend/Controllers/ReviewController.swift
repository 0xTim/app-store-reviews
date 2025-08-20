import Vapor
import Fluent

struct ReviewController: RouteCollection, Sendable {
    let reviewRepository: any ReviewRepository
    let appDataRepository: any AppDataRepository

    func boot(routes: any RoutesBuilder) throws {
        routes.get("apps", ":appID", "reviews", use: getAllReviews)
    }

    @Sendable
    func getAllReviews(req: Request) async throws -> Page<ReviewDTO> {
        let appID = try req.parameters.require("appID")

        // Make sure we've scraped reviews for this app
        guard try await appDataRepository.getLastScrapedDate(appId: appID) != nil else {
            throw Abort(.notFound)
        }
        let page: Int = req.query["page"] ?? 1
        let limit: Int = req.query["limit"] ?? 20
        let result = try await reviewRepository.getAllReviewsPaginated(appId: appID, page: page, limit: limit)
        let dtoItems = try result.items.map { try $0.toDTO() }
        let dtoPage = Page(items: dtoItems, metadata: result.metadata)
        return dtoPage
    }
}
