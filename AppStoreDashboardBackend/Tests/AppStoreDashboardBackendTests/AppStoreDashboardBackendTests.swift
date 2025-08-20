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
            #expect(appData.lastScrapedDates[appID] == Date())
        }
    }

    @Test("Test scraping works with just one page")
    func testScrapingOnePage() async throws {

    }

    @Test("Test we don't save reviews that should have already been scraped")
    func testScrapingAlreadyScraped() async throws {

    }

    @Test("Test scraping pagination with pages that have already been scraped")
    func testScrapingPaginationAlreadyScraped() async throws {

    }

    func configureForTests(app: Application) async throws {
        app.clients.use { _ in
            fakeClient
        }

        try routes(app, reviewRepository: reviewRepository, appDataRepository: appData)
    }
}
