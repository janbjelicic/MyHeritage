import Resolver

extension Resolver {

    static func registerDetails() {
        registerViewModel()
        registerViewController()
    }

    private static func registerViewModel() {
        register { _, dependencies -> DetailsViewModel in
            DetailsViewModel(dependencies: dependencies())
        }
    }

    private static func registerViewController() {
        register { _, viewModel -> DetailsViewController in
            DetailsViewController.instantiate(viewModel: viewModel())
        }
    }

}
