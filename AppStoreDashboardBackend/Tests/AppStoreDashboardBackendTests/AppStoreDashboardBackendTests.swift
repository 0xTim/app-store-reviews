@testable import AppStoreDashboardBackend
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct AppStoreDashboardBackendTests {
    let fakeClient = FakeClient()
    let appData = FakeAppDataRepository()
    let reviewRepository = FakeReviewRepository()
    let appID = "595068606"

    @Test("Test scraping works")
    func testScraping() async throws {
        try await withApp(configure: configureForTests) { app in
            fakeClient.queuedResponses = [firstPageResponse, lastPageResponse]

            try await FetchReviewsJob(appID: appID).getLatestReviews(client: app.client, logger: app.logger, reviewRepository: reviewRepository, appDataRepository: appData)
            let lastScrapedDate = try #require(appData.lastScrapedDates[appID])
            #expect((Date().timeIntervalSince1970 - lastScrapedDate.timeIntervalSince1970) < 1)
            #expect(reviewRepository.reviews.count == 100)
            #expect(fakeClient.requests.count == 2)
            #expect(fakeClient.requests[0].url.string.contains("page=1"))
            #expect(fakeClient.requests[1].url.string.contains("page=2"))
        }
    }

    @Test("Test scraping works with just one page")
    func testScrapingOnePage() async throws {
        try await withApp(configure: configureForTests) { app in
            fakeClient.queuedResponses = [lastPageResponse]

            try await FetchReviewsJob(appID: appID).getLatestReviews(client: app.client, logger: app.logger, reviewRepository: reviewRepository, appDataRepository: appData)
            let lastScrapedDate = try #require(appData.lastScrapedDates[appID])
            #expect((Date().timeIntervalSince1970 - lastScrapedDate.timeIntervalSince1970) < 1)
            #expect(reviewRepository.reviews.count == 50)
            #expect(fakeClient.requests.count == 1)
        }
    }

    @Test("Test we don't save reviews that should have already been scraped")
    func testScrapingAlreadyScraped() async throws {
        try await withApp(configure: configureForTests) { app in
            fakeClient.queuedResponses = [firstPageResponse, lastPageResponse]

            try await FetchReviewsJob(appID: appID).getLatestReviews(client: app.client, logger: app.logger, reviewRepository: reviewRepository, appDataRepository: appData)
            let lastScrapedDate = try #require(appData.lastScrapedDates[appID])
            #expect((Date().timeIntervalSince1970 - lastScrapedDate.timeIntervalSince1970) < 1)
            #expect(reviewRepository.reviews.count == 100)
            #expect(fakeClient.requests.count == 2)

            // Set up the client again as we've already popped all the responses
            fakeClient.queuedResponses = [firstPageResponse, lastPageResponse]
            try await FetchReviewsJob(appID: appID).getLatestReviews(client: app.client, logger: app.logger, reviewRepository: reviewRepository, appDataRepository: appData)
            #expect(reviewRepository.reviews.count == 100)
            let lastScrapedDate2 = try #require(appData.lastScrapedDates[appID])
            #expect(lastScrapedDate2 > lastScrapedDate)
        }
    }

    @Test("Test scraping pagination with pages that have already been scraped")
    func testScrapingPaginationAlreadyScraped() async throws {
        try await withApp(configure: configureForTests) { app in
            fakeClient.queuedResponses = [firstPageResponse, lastPageResponse]

            try await FetchReviewsJob(appID: appID).getLatestReviews(client: app.client, logger: app.logger, reviewRepository: reviewRepository, appDataRepository: appData)

            // Set up the client again as we've already popped all the responses
            fakeClient.queuedResponses = [firstPageResponse, lastPageResponse]
            try await FetchReviewsJob(appID: appID).getLatestReviews(client: app.client, logger: app.logger, reviewRepository: reviewRepository, appDataRepository: appData)
            #expect(reviewRepository.reviews.count == 100)
            // We always scrape at least one page so there should be one more request since the reviews are older than the last
            // scraped date
            #expect(fakeClient.requests.count == 3)
            // Make sure we're only requesting JSON and not XML
            #expect(fakeClient.requests.filter({ $0.url.string.contains("xml") }).count == 0)
        }
    }

    func configureForTests(app: Application) async throws {
        app.clients.use { _ in
            fakeClient
        }

        try routes(app, reviewRepository: reviewRepository, appDataRepository: appData)
    }
}
