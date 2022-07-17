@testable import MyHeritage

extension PodcastItem: Equatable {

    public static func == (lhs: PodcastItem, rhs: PodcastItem) -> Bool {
        lhs.artist == rhs.artist &&
        lhs.track == rhs.track &&
        lhs.podcastImage == rhs.podcastImage &&
        lhs.releaseDate == rhs.releaseDate
    }

}
