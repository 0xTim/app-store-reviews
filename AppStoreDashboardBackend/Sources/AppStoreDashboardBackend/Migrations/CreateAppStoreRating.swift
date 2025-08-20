import Fluent

struct CreateReview: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Review.v20250819.schema)
            .field(Review.v20250819.id, .int, .identifier(auto: false))
            .field(Review.v20250819.content, .string, .required)
            .field(Review.v20250819.score, .int, .required)
            .field(Review.v20250819.reviewDate, .datetime, .required)
            .field(Review.v20250819.author, .string, .required)
            .field(Review.v20250819.reviewLink, .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Review.v20250819.schema).delete()
    }
}
