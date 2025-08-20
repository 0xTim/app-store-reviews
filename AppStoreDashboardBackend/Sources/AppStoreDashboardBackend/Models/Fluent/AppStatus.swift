import Foundation
import Fluent

final class AppStatus: Model, @unchecked Sendable {
    static let schema = v20250819.schema

    @ID(custom: v20250819.id, generatedBy: .user)
    var id: String?

    @Field(key: v20250819.lastScrapedDate)
    var lastScrapedDate: Date

    @Field(key: v20250819.appId)
    var appId: String

    init() { }

    init(id: String? = nil, lastScrapedDate: Date, appId: String) {
        self.id = id
        self.lastScrapedDate = lastScrapedDate
        self.appId = appId
    }
}
