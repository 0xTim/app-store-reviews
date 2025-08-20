import Vapor

struct ReviewDTO: Content {
    let id: Int
    let content: String
    let score: Int
    let reviewDate: Date
    let author: String
    let reviewLink: String
}
