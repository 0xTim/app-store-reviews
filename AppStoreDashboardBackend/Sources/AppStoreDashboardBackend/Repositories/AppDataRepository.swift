import Foundation

/// Repository for managing app data such as last scraped date.
protocol AppDataRepository: Sendable {

    /// Get the last scraped date for a specific app.
    /// - Parameter appId: The ID of the app to retrieve the last scraped date for.
    /// - Returns: The `Date` of the last scrape for the app. If the app has never been scraped, this will return `nil`.
    func getLastScrapedDate(appId: String) async throws -> Date?


    /// The the last scraped date for a specific app.
    /// - Parameters:
    ///   - appId: The ID of the app to save the last scraped date for.
    ///   - date: The date the last scrape was performed.
    func saveLastScrapedDate(appId: String, date: Date) async throws
}
