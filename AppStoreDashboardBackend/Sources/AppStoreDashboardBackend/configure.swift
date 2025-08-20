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

    // Run the migrations before we try and do any actual work
    try await app.autoMigrate()

    app.middleware.use(SecurityHeadersFactory.api().build(), at: .beginning)

    guard let appID = Environment.get("APP_ID") else {
        fatalError("APP_ID environment variable is not set")
    }

    let job = FetchReviewsJob(appID: appID)
    app.queues.schedule(job).minutely().at(0)

    // Do an initial scrape so we have some data on app start
    let reviewRepository = FluentReviewRepository(database: app.db, logger: app.logger)
    let appDataRepository = FluentAppDataRepository(database: app.db)
    try await job.getLatestReviews(client: app.client, logger: app.logger, reviewRepository: reviewRepository, appDataRepository: appDataRepository)

    try app.queues.startScheduledJobs()

    // register routes
    try routes(app, reviewRepository: reviewRepository, appDataRepository: appDataRepository)
}
