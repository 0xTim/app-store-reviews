import Foundation
import Vapor

// Codable model mapping the app store review feed response
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
    let updated: Date
    let rating: Int
    let version: LabelValue
    let id: Int
    let title: String
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

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(EntryAuthor.self, forKey: .author)
        // Updated, ID, and Rating are wrapped in a LabelValue struct, which isn't nice to use so flatten it here
        let updatedWrapper = try container.decode(LabelValue.self, forKey: .updated)
        guard let updatedDate = ISO8601DateFormatter().date(from: updatedWrapper.label) else {
            throw DecodingError.dataCorruptedError(forKey: .updated,
                                                   in: container,
                                                   debugDescription: "Updated date is not in ISO8601 format")
        }
        self.updated = updatedDate
        let idWrapper = try container.decode(LabelValue.self, forKey: .id)
        guard let idInt = Int(idWrapper.label) else {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                   in: container,
                                                   debugDescription: "ID is not an Int")
        }
        self.id = idInt
        let ratingWrapper = try container.decode(LabelValue.self, forKey: .rating)
        guard let ratingInt = Int(ratingWrapper.label) else {
            throw DecodingError.dataCorruptedError(forKey: .rating,
                                                   in: container,
                                                   debugDescription: "Rating is not an Int")
        }
        let titleWrapper = try container.decode(LabelValue.self, forKey: .rating)
        self.title = titleWrapper.label
        self.rating = ratingInt
        self.title = try container.decode(LabelValue.self, forKey: .title)
        self.content = try container.decode(ReviewContent.self, forKey: .content)
        self.link = try container.decode(Link.self, forKey: .link)
        self.version = try container.decode(LabelValue.self, forKey: .version)
        self.voteSum = try container.decode(LabelValue.self, forKey: .voteSum)
        self.contentType = try container.decode(ContentType.self, forKey: .contentType)
        self.voteCount = try container.decode(LabelValue.self, forKey: .voteCount)
    }
}

struct EntryAuthor: Codable {
    let uri: LabelValue
    let name: String
    let label: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.decode(LabelValue.self, forKey: .uri)
        let nameWrapper = try container.decode(LabelValue.self, forKey: .name)
        self.name = nameWrapper.label
        self.label = try container.decode(String.self, forKey: .label)
    }
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
