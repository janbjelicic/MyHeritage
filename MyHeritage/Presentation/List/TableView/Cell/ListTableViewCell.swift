import Kingfisher
import UIKit

class ListTableViewCell: UITableViewCell {

    static var reuseIdentifier: String = "ListTableViewCell"

    // MARK: - Outlets
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var trackLabel: UILabel!
    @IBOutlet private weak var podcastImageView: UIImageView!

    // MARK: - Public functions
    func configure(with item: PodcastItem) {
        artistLabel.text = item.artist
        trackLabel.text = item.track

        let url = URL(string: item.podcastImage)
        podcastImageView.kf.indicatorType = .activity
        podcastImageView.kf.setImage(with: url)
    }

}
