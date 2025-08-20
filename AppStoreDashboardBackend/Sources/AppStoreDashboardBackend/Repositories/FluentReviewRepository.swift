import Fluent
import FluentSQLiteDriver

struct FluentReviewRepository: ReviewRepository {
    let database: any Database
    let logger: Logger

    func save(_ review: Review) async throws {
        do {
            try await review.save(on: database)
        } catch {
            if let sqliteError = error as? SQLiteError, sqliteError.reason == .constraintPrimaryKeyFailed {
                // Swallow unique constraint errors as we already have saved this review
                let id = try review.requireID()
                logger.debug("Already saved this review", metadata: [
                    "reviewID": "\(id)",
                ])
                return
            }
            throw error
        }
    }
}

