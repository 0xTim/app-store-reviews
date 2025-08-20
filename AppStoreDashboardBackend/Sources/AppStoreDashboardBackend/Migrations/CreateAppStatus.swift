import Fluent

struct CreateAppStatus: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(AppStatus.v20250819.schema)
            .id()
            .field(AppStatus.v20250819.appId, .string, .required)
            .field(AppStatus.v20250819.lastScrapedDate, .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(AppStatus.v20250819.schema).delete()
    }
}
