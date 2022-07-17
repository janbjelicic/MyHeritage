@testable import MyHeritage

extension PodcastResponse: Equatable {

    public static func == (lhs: PodcastResponse, rhs: PodcastResponse) -> Bool {
        lhs.artistName == rhs.artistName &&
        lhs.trackName == rhs.trackName &&
        lhs.artwork == rhs.artwork &&
        lhs.releaseDate == rhs.releaseDate
    }

}
