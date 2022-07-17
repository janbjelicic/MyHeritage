import Foundation
import Resolver

enum HttpVerb: String {

    case get = "GET"
    case post = "POST"

}

protocol NetworkRequest {

    var path: String { get }
    var method: HttpVerb { get }
    var parameters: [String: Any]? { get }

}

extension NetworkRequest {

    private var baseUrl: String {
        "https://itunes.apple.com/"
    }

    private var url: URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        urlComponents.path += path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    public func urlRequest() -> URLRequest? {
        guard let url = url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        // If headers are different for different requests this could be also added to the NetworkRequest protocol.
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]

        urlRequest.httpBody = jsonBody
        return urlRequest
    }

    private var queryItems: [URLQueryItem]? {
        // Chek if it is a GET method.
        guard method == .get, let parameters = parameters else {
            return nil
        }
        // Convert parameters to query items.
        return parameters.map { (key: String, value: Any) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }

    /// Returns the URLRequest body `Data`
    private var jsonBody: Data? {
        guard method == .post, let parameters = parameters else {
            return nil
        }

        // Convert parameters to JSON data
        var body: Data?
        do {
            body = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .prettyPrinted)
        } catch {
            print(error)
        }
        return body
    }

}
