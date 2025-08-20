import Fluent

extension Review {
    enum v20250819 {
        static let schema = "reviews"
        static let id = FieldKey("id")
        static let content = FieldKey("content")
        static let score = FieldKey("score")
        static let reviewDate = FieldKey("review_date")
        static let author = FieldKey("author")
        static let reviewLink = FieldKey("review_link")
        static let appID = FieldKey("app_id")
    }
}

extension AppStatus {
    enum v20250819 {
        static let schema = "app_status"
        static let id = FieldKey("id")
        static let lastScrapedDate = FieldKey("last_scraped_date")
        static let appId = FieldKey("app_id")
    }
}
