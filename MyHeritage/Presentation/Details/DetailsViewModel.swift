import UIKit
import RxCocoa
import RxSwift

class DetailsViewModel {

    struct Output {
        let podcastImage = BehaviorRelay<String?>(value: nil)
        let artist = BehaviorRelay<String?>(value: nil)
        let track = BehaviorRelay<String?>(value: nil)
        let releaseDate = BehaviorRelay<String?>(value: nil)
    }

    // MARK: - Public properties
    let output = Output()

    // MARK: - Private properties
    private let dependencies: DetailsDependencies

    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(dependencies: DetailsDependencies) {
        self.dependencies = dependencies

        bindOutputs()
    }

    private func bindOutputs() {
        output.podcastImage.accept(dependencies.item.podcastImage)
        output.artist.accept(dependencies.item.artist)
        output.track.accept(dependencies.item.track)
        output.releaseDate.accept(dependencies.item.releaseDate)
    }

}
