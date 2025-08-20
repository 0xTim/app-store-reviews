import FluentKit

protocol ReviewRepository: Sendable {
    func save(_ review: Review) async throws
    func getAllReviewsPaginated(appId: String, page: Int, limit: Int) async throws -> Page<Review>
}
