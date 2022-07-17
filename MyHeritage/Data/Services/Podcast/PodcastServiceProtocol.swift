import Foundation
import RxSwift

protocol PodcastServiceProtocol {

    func getPodcasts(_ request: PodcastRequest) -> Single<PodcastsResponse>

}
