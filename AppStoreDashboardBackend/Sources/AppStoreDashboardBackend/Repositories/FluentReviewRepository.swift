import Fluent

struct FluentReviewRepository: ReviewRepository {   
    let database: any Database
    
    func save(_ review: Review) async throws {
        try await review.save(on: database)
    }
}

