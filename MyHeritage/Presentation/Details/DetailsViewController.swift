import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var podcastImageView: UIImageView!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var trackLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!

    // MARK: - Data
    weak var coordinator: AppCoordinator?

    private var viewModel: DetailsViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Init
    static func instantiate(viewModel: DetailsViewModel) -> DetailsViewController {
        let viewController = Storyboard.Main.instantiate(DetailsViewController.self)
        viewController.viewModel = viewModel
        return viewController
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindOutputs()
    }

    // MARK: - UI
    private func setupUI() {
        title = "Details"
    }

    private func bindOutputs() {
        viewModel.output.podcastImage
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let self = self,
                      let value = value else { return }

                let url = URL(string: value)
                self.podcastImageView.kf.indicatorType = .activity
                self.podcastImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)

        viewModel.output.artist
            .asDriver()
            .drive(artistLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.track
            .asDriver()
            .drive(trackLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.releaseDate
            .asDriver()
            .drive(releaseDateLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
