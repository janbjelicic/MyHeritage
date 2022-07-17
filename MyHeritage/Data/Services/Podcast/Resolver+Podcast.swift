import Resolver

extension Resolver {

    static func registerPodcast() {
        registerServices()
    }

    private static func registerServices() {
        register {
            PodcastService(networkManager: resolve())
        }
        .implements(PodcastServiceProtocol.self)
        .scope(.shared)
    }

}
