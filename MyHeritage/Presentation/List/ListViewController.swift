import RxCocoa
import RxSwift
import UIKit

class ListViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Data
    weak var coordinator: AppCoordinator?

    private var viewModel: ListViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Init
    static func instantiate(viewModel: ListViewModel) -> ListViewController {
        let viewController = Storyboard.Main.instantiate(ListViewController.self)
        viewController.viewModel = viewModel
        return viewController
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindInputs()
        bindOutputs()
    }

    // MARK: - UI
    private func setupUI() {
        title = "Podcasts"
        setupPullToRefresh()
    }

    private func setupPullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
    }

    @objc private func refreshTriggered() {
        viewModel.input.action.onNext(.loadPodcasts(searchBar.text ?? ""))
    }

    private func bindInputs() {
        tableView.rx.modelSelected(PodcastItem.self)
            .map { .selectedItem($0) }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { .loadPodcasts($0) }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.output.items
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: ListTableViewCell.reuseIdentifier,
                                      cellType: ListTableViewCell.self)) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)

        viewModel.output.isTableViewHidden
            .asDriver()
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output.hideTableViewRefreshControl
            .asSignal()
            .emit(with: self, onNext: { owner, _ in
                owner.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)

        viewModel.output.isLoaderAnimating
            .asDriver()
            .drive(with: self, onNext: { owner, isAnimating in
                owner.activityIndicatorView.isHidden = !isAnimating
                if isAnimating {
                    owner.activityIndicatorView.startAnimating()
                } else {
                    owner.activityIndicatorView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.showError
            .asSignal()
            .emit(onNext: showError)
            .disposed(by: disposeBag)

        viewModel.output.showDetailsScreen
            .asSignal()
            .emit(onNext: showDetailsScreen)
            .disposed(by: disposeBag)
    }

    private func showDetailsScreen(_ dependencies: DetailsDependencies) {
        coordinator?.showDetailsScreen(dependencies)
    }

    private func showError(_ information: ErrorInformation) {
        let alert = UIAlertController(title: information.name,
                                      message: information.message,
                                      preferredStyle: .alert)

        let closeAction = UIAlertAction(title: "Close",
                                        style: .default)

        alert.addAction(closeAction)
        present(alert, animated: false)
    }

}

extension ListViewController: UITableViewDelegate {

}
