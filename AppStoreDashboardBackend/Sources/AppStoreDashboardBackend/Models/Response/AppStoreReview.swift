import Foundation
import Vapor

struct FeedResponse: Content {
    let feed: Feed
}

struct Feed: Codable {
    let author: Author
    let entry: [Entry]
    let updated: LabelValue
    let rights: LabelValue
    let title: LabelValue
    let icon: LabelValue
    let link: [Link]
    let id: LabelValue
}

struct Author: Codable {
    let name: LabelValue
    let uri: LabelValue
}

struct Entry: Codable {
    let author: EntryAuthor
    let updated: LabelValue
    let rating: LabelValue
    let version: LabelValue
    let id: LabelValue
    let title: LabelValue
    let content: ReviewContent
    let link: Link
    let voteSum: LabelValue
    let contentType: ContentType
    let voteCount: LabelValue

    enum CodingKeys: String, CodingKey {
        case author, updated, id, title, content, link
        case rating = "im:rating"
        case version = "im:version"
        case voteSum = "im:voteSum"
        case contentType = "im:contentType"
        case voteCount = "im:voteCount"
    }
}

struct EntryAuthor: Codable {
    let uri: LabelValue
    let name: LabelValue
    let label: String
}

struct ReviewContent: Codable {
    let label: String
    let attributes: Attributes
}

struct ContentType: Codable {
    let attributes: ContentTypeAttributes
}

struct ContentTypeAttributes: Codable {
    let term: String
    let label: String
}

struct Link: Codable {
    let attributes: LinkAttributes
}

struct LinkAttributes: Codable {
    let rel: String
    let type: String?
    let href: String
}

struct Attributes: Codable {
    let type: String
}

struct LabelValue: Codable {
    let label: String
}
