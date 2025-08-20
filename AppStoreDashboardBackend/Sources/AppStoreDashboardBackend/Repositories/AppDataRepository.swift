import Foundation

protocol AppDataRepository: Sendable {
    func getLastScrapedDate(appId: String) async throws -> Date?
    func saveLastScrapedDate(appId: String, date: Date) async throws
}
