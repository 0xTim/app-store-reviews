import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor
import VaporSecurityHeaders

// configures your application
public func configure(_ app: Application) async throws {
    if app.environment == .development {
        app.logger.logLevel = .debug
    }
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateReview())
    app.migrations.add(CreateAppStatus())

    app.middleware.use(SecurityHeadersFactory.api().build(), at: .beginning)

    guard let appID = Environment.get("APP_ID") else {
        fatalError("APP_ID environment variable is not set")
    }

    let job = FetchReviewsJob(appID: appID)
    app.queues.schedule(job).minutely().at(0)

    try app.queues.startScheduledJobs()

    // register routes
    try routes(app)

    try await app.autoMigrate()
}
