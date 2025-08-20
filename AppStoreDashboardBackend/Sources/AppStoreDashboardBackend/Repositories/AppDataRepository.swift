import Foundation

protocol AppDataRepository {
    func getLastScrapedDate(appId: String) async throws -> Date?
    func saveLastScrapedDate(appId: String, date: Date) async throws
}
