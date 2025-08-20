import Fluent
import Foundation
@testable import AppStoreDashboardBackend

final class FakeReviewRepository: ReviewRepository, @unchecked Sendable {
    var reviews: [Review] = []

    func save(_ review: Review) async throws {
        self.reviews.append(review)
    }

    func getAllReviewsPaginated(appId: String, timeLimit: Int?, page: Int, limit: Int) async throws -> Page<Review> {
        var reviewsToReturn = self.reviews.filter { $0.appID == appId }

        if let timeLimit {
            let cutoffDate = Date().addingTimeInterval(-TimeInterval(timeLimit)) // Convert hours to seconds
            reviewsToReturn = reviewsToReturn.filter { $0.reviewDate >= cutoffDate }
        }

        let totalCount = reviewsToReturn.count
        let startIndex = (page - 1) * limit
        let endIndex = min(startIndex + limit, totalCount)
        let paginatedReviews = Array(reviewsToReturn[startIndex..<endIndex])
        return Page(
            items: paginatedReviews,
            metadata: PageMetadata(page: page, per: limit, total: totalCount)
        )
    }
}
