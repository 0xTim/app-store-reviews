import Foundation
import Fluent

final class AppStatus: Model, @unchecked Sendable {
    static let schema = v20250819.schema

    @ID
    var id: UUID?

    @Field(key: v20250819.lastScrapedDate)
    var lastScrapedDate: Date

    @Field(key: v20250819.appId)
    var appId: String

    init() { }

    init(id: UUID? = nil, lastScrapedDate: Date, appId: String) {
        self.id = id
        self.lastScrapedDate = lastScrapedDate
        self.appId = appId
    }
}
