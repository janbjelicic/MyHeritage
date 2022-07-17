@testable import MyHeritage

extension PodcastsResponse: Equatable {

    public static func == (lhs: PodcastsResponse, rhs: PodcastsResponse) -> Bool {
        lhs.results == rhs.results
    }

}
