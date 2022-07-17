import Resolver

extension Resolver {

    static func registerList() {
        registerMappers()
        registerViewModel()
        registerViewController()
    }

    private static func registerMappers() {
        register {
            PodcastItemMapper()
        }
        .implements(PodcastItemMapperProtocol.self)
        .scope(.shared)
    }

    private static func registerViewModel() {
        register {
            ListViewModel(podcastItemMapper: resolve(),
                          podcastService: resolve())
        }
    }

    private static func registerViewController() {
        register {
            ListViewController.instantiate(viewModel: resolve())
        }
    }

}
