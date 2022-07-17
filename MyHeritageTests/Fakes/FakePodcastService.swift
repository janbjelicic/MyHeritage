import Foundation
@testable import MyHeritage
import RxSwift

class FakePodcastService: PodcastServiceProtocol {

    private let podcastsResponse: PodcastsResponse?

    init(podcastsResponse: PodcastsResponse? = nil) {
        self.podcastsResponse = podcastsResponse
    }

    func getPodcasts(_ request: PodcastRequest) -> Single<PodcastsResponse> {
        if let podcastsResponse = podcastsResponse {
            return .just(podcastsResponse)
        } else {
            return .error(NetworkError.generic)
        }
    }

}
