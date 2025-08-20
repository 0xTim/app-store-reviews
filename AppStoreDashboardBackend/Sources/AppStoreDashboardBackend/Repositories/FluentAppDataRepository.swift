import Fluent
import Foundation

struct FluentAppDataRepository: AppDataRepository {
    let database: any Database

    func getLastScrapedDate(appId: String) async throws -> Date? {
        try await AppStatus.query(on: database).filter(\.$appId == appId).first()?.lastScrapedDate
    }

    func saveLastScrapedDate(appId: String, date: Date) async throws {
        if let appStatus = try await AppStatus.query(on: database).filter(\.$appId == appId).first() {
            appStatus.lastScrapedDate = date
            try await appStatus.update(on: database)
        } else {
            // Assume we haven't seen this app before
            let newAppStatus = AppStatus(lastScrapedDate: date, appId: appId)
            try await newAppStatus.create(on: database)
        }
    }
}
