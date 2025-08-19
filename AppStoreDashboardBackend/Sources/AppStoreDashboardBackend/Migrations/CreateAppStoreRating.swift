import Fluent

struct CreateReview: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("reviews")
            .field("id", .int, .identifier(auto: false))
            .field("content", .string, .required)
            .field("score", .int, .required)
            .field("review_date", .datetime, .required)
            .field("author", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("reviews").delete()
    }
}
