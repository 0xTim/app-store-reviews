import Vapor

// Represents a DTO for a Review as returned by the API
struct ReviewDTO: Content {
    let id: Int
    let content: String
    let score: Int
    let reviewDate: Date
    let author: String
    let reviewLink: String
    let title: String
}
