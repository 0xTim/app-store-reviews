import Fluent

struct CreateReview: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("reviews")
            .field(Review.v20250819.id, .int, .identifier(auto: false))
            .field(Review.v20250819.content, .string, .required)
            .field("score", .int, .required)
            .field("review_date", .datetime, .required)
            .field("author", .string, .required)
            .field("review_link", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("reviews").delete()
    }
}
