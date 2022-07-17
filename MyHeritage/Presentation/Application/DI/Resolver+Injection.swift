import Resolver

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        registerAPI()
        registerPodcast()

        registerList()
        registerDetails()
    }

}
