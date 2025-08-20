import Fluent

struct CreateAppStatus: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(AppStatus.v20250819.schema)
            .field(AppStatus.v20250819.id, .string, .identifier(auto: false))
            .field(AppStatus.v20250819.lastScrapedDate, .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(AppStatus.v20250819.schema).delete()
    }
}
