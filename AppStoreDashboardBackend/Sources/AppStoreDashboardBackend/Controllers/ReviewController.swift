import Vapor

struct ReviewController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
    }

    func getAllReviews(req: Request) async throws -> [ReviewDTO] {
        []
    }
}
