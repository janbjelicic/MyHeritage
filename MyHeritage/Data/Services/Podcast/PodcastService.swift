import Foundation
import RxSwift

final class PodcastService: PodcastServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func getPodcasts(_ request: PodcastRequest) -> Single<PodcastsResponse> {
        networkManager.request(request: request)
    }

}
