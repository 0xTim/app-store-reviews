import Fluent
import Foundation

final class Review: Model, @unchecked Sendable {
    static let schema = "reviews"

    @ID(custom: v20250819.id, generatedBy: .user)
    var id: Int?

    @Field(key: v20250819.content)
    var content: String

    @Field(key: "score")
    var score: Int

    @Field(key: "review_date")
    var reviewDate: Date

    @Field(key: "author")
    var author: String

    @Field(key: "review_link")
    var reviewLink: String

    init() { }

    init(id: Int, content: String, score: Int, reviewDate: Date, author: String, reviewLink: String) {
        self.id = id
        self.content = content
        self.score = score
        self.reviewDate = reviewDate
        self.author = author
        self.reviewLink = reviewLink
    }
    
//    func toDTO() -> TodoDTO {
//        .init(
//            id: self.id,
//            title: self.$content.value
//        )
//    }
}
