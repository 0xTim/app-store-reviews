import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor
import VaporSecurityHeaders

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateReview())

    app.middleware.use(SecurityHeadersFactory.api().build(), at: .beginning)

    // register routes
    try routes(app)
}
