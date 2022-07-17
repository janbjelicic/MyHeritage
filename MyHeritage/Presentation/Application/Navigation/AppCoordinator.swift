import Resolver
import UIKit

class AppCoordinator: Coordinator {

    private let window: UIWindow
    var childrenCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let listViewController = Resolver.resolve(ListViewController.self)
        listViewController.coordinator = self

        navigationController.pushViewController(listViewController, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showDetailsScreen(_ dependencies: DetailsDependencies) {
        let detailsViewModel = Resolver.resolve(DetailsViewModel.self, args: dependencies)
        let detailsViewController = Resolver.resolve(DetailsViewController.self, args: detailsViewModel)
        detailsViewController.coordinator = self

        navigationController.pushViewController(detailsViewController, animated: true)
    }

}
