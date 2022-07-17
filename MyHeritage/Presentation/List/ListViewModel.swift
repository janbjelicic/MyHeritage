import Foundation
import RxCocoa
import RxSwift

class ListViewModel {

    enum Action {
        case loadPodcasts(String)
        case selectedItem(PodcastItem)
    }

    struct Input {
        let action = PublishSubject<Action>()
    }

    struct Output {
        let items = BehaviorRelay<[PodcastItem]>(value: [])
        let isLoaderAnimating = BehaviorRelay<Bool>(value: false)
        let isTableViewHidden = BehaviorRelay<Bool>(value: true)

        let hideTableViewRefreshControl = PublishRelay<Void>()
        let showError = PublishRelay<ErrorInformation>()
        let showDetailsScreen = PublishRelay<DetailsDependencies>()
    }

    // MARK: - Public properties
    let input = Input()
    let output = Output()

    // MARK: - Private properties
    private let podcastItemMapper: PodcastItemMapperProtocol
    private let podcastService: PodcastServiceProtocol

    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(podcastItemMapper: PodcastItemMapperProtocol,
         podcastService: PodcastServiceProtocol) {
        self.podcastItemMapper = podcastItemMapper
        self.podcastService = podcastService

        bindInputs()
    }

    private func bindInputs() {
        input.action
            .subscribe(with: self, onNext: { owner, action in
                switch action {
                case .loadPodcasts(let term):
                    owner.handleLoadPodcasts(term)
                case .selectedItem(let item):
                    owner.handleSelectedItem(item)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    private func handleLoadPodcasts(_ term: String) {
        let request = PodcastRequest(term: term)

        output.isLoaderAnimating.accept(true)
        output.isTableViewHidden.accept(true)

        podcastService.getPodcasts(request)
            .subscribe(with: self, onSuccess: { owner, podcasts in
                let items = owner.podcastItemMapper(podcasts)
                owner.output.items.accept(items)

                owner.output.isLoaderAnimating.accept(false)
                owner.output.isTableViewHidden.accept(false)
                owner.output.hideTableViewRefreshControl.accept(())
            }, onFailure: { owner, error in
                let errorInformation = ErrorInformation(name: "Error",
                                                        message: "Something went wrong, please try again.")

                guard let networkError = error as? NetworkError else {
                    owner.handleError(errorInformation)
                    return
                }

                switch networkError {
                case .descriptive(let information):
                    owner.handleError(information)
                default:
                    owner.handleError(errorInformation)
                }
            })
            .disposed(by: disposeBag)
    }

    private func handleSelectedItem(_ item: PodcastItem) {
        let dependencies = DetailsDependencies(item: item)

        output.showDetailsScreen.accept(dependencies)
    }

    private func handleError(_ errorInformation: ErrorInformation) {
        output.hideTableViewRefreshControl.accept(())
        output.isLoaderAnimating.accept(false)
        output.isTableViewHidden.accept(false)
        output.items.accept([])
        output.showError.accept(errorInformation)
    }

}
