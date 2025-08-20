import Fluent
import Foundation
@testable import AppStoreDashboardBackend

final class FakeAppDataRepository: AppDataRepository, @unchecked Sendable {
    var lastScrapedDates: [String: Date] = [:]

    func getLastScrapedDate(appId: String) async throws -> Date? {
        return lastScrapedDates[appId]
    }

    func saveLastScrapedDate(appId: String, date: Date) async throws {
        self.lastScrapedDates[appId] = date
    }
}
