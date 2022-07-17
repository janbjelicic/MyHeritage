import Foundation

struct PodcastResponse: Decodable {

    let artistName: String
    let trackName: String
    let artwork: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case artwork = "artworkUrl100"
        case releaseDate
    }

}
