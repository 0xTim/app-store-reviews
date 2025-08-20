import FluentKit

/// Repository protocol for getting app store reviews from persistent storage.
protocol ReviewRepository: Sendable {

    /// Save a new review to the database.
    /// - Parameter review: The `Review` object to save.
    func save(_ review: Review) async throws

    /// Get all of the reviews for a specific app. This will return a paginated list, so the response doesn't get too large.
    /// - Parameters:
    ///   - appId: The ID of the app to get reviews for.
    ///   - timeLimit: How many hours back to get reviews for. If `nil`, all reviews will be returned.
    ///   - page: The page number to retrieve. This is used for paginate the results, along with `limit`.
    ///   - limit: The number of reviews to return per page.
    /// - Returns: A pagnated list of reviews for the specified app.
    func getAllReviewsPaginated(appId: String, timeLimit: Int?, page: Int, limit: Int) async throws -> Page<Review>
}
