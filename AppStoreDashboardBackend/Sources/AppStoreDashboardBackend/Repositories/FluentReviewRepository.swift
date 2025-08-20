import Fluent
import FluentSQLiteDriver
import Foundation

struct FluentReviewRepository: ReviewRepository {
    let database: any Database
    let logger: Logger

    func save(_ review: Review) async throws {
        do {
            try await review.save(on: database)
        } catch {
            if let sqliteError = error as? SQLiteError, sqliteError.reason == .constraintPrimaryKeyFailed {
                // Swallow unique constraint errors as we've already saved this review.
                // We should never really hit this error as we check the last scrape date against the
                // updated date of the review, but just in case.
                let id = try review.requireID()
                logger.debug("Already saved this review", metadata: [
                    "reviewID": "\(id)",
                ])
                return
            }
            throw error
        }
    }

    func getAllReviewsPaginated(appId: String, timeLimit: Int?, page: Int, limit: Int) async throws -> Page<Review> {
        let query = Review.query(on: database)
            .filter(\.$appID == appId)
            .sort(\.$reviewDate, .descending)

        if let timeLimit {
            query.filter(\.$reviewDate >= Date().addingTimeInterval(-TimeInterval(timeLimit)))
        }

        return try await query
            .page(withIndex: page, size: limit)
            .get()
    }
}

