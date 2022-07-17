import UIKit

@testable import MyHeritage

struct PodcastBuilder {

    static let podcastsResponse = PodcastsResponse(results: [podcastResponse])

    private static let podcastResponse = PodcastResponse(artistName: "Somebody",
                                                         trackName: "Somewhere",
                                                         artwork: "Art of someone",
                                                         releaseDate: "01.01.2000")

    static let podcastItem = PodcastItem(artist: "Somebody",
                                         track: "Somewhere",
                                         podcastImage: "url",
                                         releaseDate: "01.01.2000")

}
