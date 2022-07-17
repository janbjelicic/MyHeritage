import Foundation

class PodcastItemMapper: PodcastItemMapperProtocol {

    func callAsFunction(_ data: PodcastsResponse) -> [PodcastItem] {
        var items: [PodcastItem] = []
        for podcast in data.results {
            let releaseDateValue = ISO8601DateFormatter().date(from: podcast.releaseDate)

            items.append(PodcastItem(artist: podcast.artistName,
                                     track: podcast.trackName,
                                     podcastImage: podcast.artwork,
                                     releaseDate: releaseDateValue?.formatted(date: .abbreviated, time: .omitted) ?? ""))
        }

        return items
    }

}
