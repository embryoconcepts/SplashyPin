import Foundation

typealias Photos = [Photo]


struct Photo: Codable {
    enum CodingKeys: String, CodingKey {
        case id, description, urls
        case altDescription = "alt_description"
    }

    let id: String
    let description: String?
    let altDescription: String?
    let urls: URLs
}

struct URLs: Codable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}
