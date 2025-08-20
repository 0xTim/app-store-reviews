import Fluent
import FluentSQL

struct CreateReview: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Review.v20250819.schema)
            .field(Review.v20250819.id, .int, .identifier(auto: false))
            .field(Review.v20250819.content, .string, .required)
            .field(Review.v20250819.score, .int, .required)
            .field(Review.v20250819.reviewDate, .datetime, .required)
            .field(Review.v20250819.author, .string, .required)
            .field(Review.v20250819.reviewLink, .string, .required)
            .field(Review.v20250819.appID, .string, .required)
            .field(Review.v20250819.title, .string, .required)
            .create()

        // Add an index to the table on `app_id` since it will be frequently queried
        guard let sqlDatabase = database as? any SQLDatabase else {
            fatalError("Not an SQL Database")
        }
        try await sqlDatabase.create(index: "app_id_index")
            .on(Review.v20250819.schema)
            .column(Review.v20250819.appID.description)
            .run()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Review.v20250819.schema).delete()
    }
}
