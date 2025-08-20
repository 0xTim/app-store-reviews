import Fluent
import Vapor

func routes(_ app: Application, reviewRepository: any ReviewRepository, appDataRepository: any AppDataRepository) throws {
    app.get("hc") { req async in
        "OK"
    }

    try app.register(collection: ReviewController(reviewRepository: reviewRepository, appDataRepository: appDataRepository))
}
