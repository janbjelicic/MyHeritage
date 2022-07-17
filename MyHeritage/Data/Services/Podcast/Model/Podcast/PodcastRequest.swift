import Foundation

struct PodcastRequest: Encodable {

    let term: String

}

extension PodcastRequest: NetworkRequest {

    var path: String {
        "search"
    }

    var method: HttpVerb {
        .get
    }

    var parameters: [String: Any]? {
        ["term": term,
         "entity": "podcast"]
    }

}
