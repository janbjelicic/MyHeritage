import Foundation

protocol PodcastItemMapperProtocol {

    func callAsFunction(_ data: PodcastsResponse) -> [PodcastItem]

}
