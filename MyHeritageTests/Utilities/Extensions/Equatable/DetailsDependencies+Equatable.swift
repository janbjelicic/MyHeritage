@testable import MyHeritage

extension DetailsDependencies: Equatable {

    public static func == (lhs: DetailsDependencies, rhs: DetailsDependencies) -> Bool {
        lhs.item == rhs.item
    }

}
