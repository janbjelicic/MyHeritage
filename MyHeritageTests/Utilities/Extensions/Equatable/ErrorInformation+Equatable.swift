@testable import MyHeritage

extension ErrorInformation: Equatable {

    public static func == (lhs: ErrorInformation, rhs: ErrorInformation) -> Bool {
        lhs.name == rhs.name &&
        lhs.message == rhs.message
    }

}
