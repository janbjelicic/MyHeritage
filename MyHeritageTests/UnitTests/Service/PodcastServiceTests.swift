@testable import MyHeritage

import RxSwift
import XCTest

class PodcastServiceTests: XCTestCase {

    private enum Endpoint {
        static let endpointSearch = "search"
    }

    var sut: PodcastService!
    var networkManager: FakeNetworkManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        networkManager = nil
        disposeBag = nil
    }

    // MARK: - Helpers
    private func setupTestData(responseJSON: String? = nil,
                               error: Error? = nil) {
        networkManager = FakeNetworkManager(responseJSON: responseJSON,
                                            error: error)

        sut = PodcastService(networkManager: networkManager)
    }

    // MARK: - Tests
    func testGetPodcastsRequestDetails() {
        let responseJSON = TestUtilities.loadTextFile("podcasts.json")
        setupTestData(responseJSON: responseJSON)

        let expectedResponse = PodcastBuilder.podcastsResponse

        let searchTerm = "Search"
        let request = PodcastRequest(term: searchTerm)

        let expectation = XCTestExpectation(description: #function)
        sut.getPodcasts(request)
            .subscribe(onSuccess: { response in
                XCTAssertEqual(expectedResponse, response)
                expectation.fulfill()
            }, onFailure: { _ in
                XCTFail("testPodcastsRequestDetails shouldn't fail.")
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        let expectedMethod = HttpVerb.get
        let expectedPath = Endpoint.endpointSearch
        let expectedParameters: [String: Any] = ["term": searchTerm,
                                                 "entity": "podcast"]

        XCTAssertEqual(expectedMethod, networkManager.method)
        XCTAssertEqual(expectedPath, networkManager.path)

        XCTAssertEqual(expectedParameters["term"] as! String, networkManager.parameters!["term"] as! String)
        XCTAssertEqual(expectedParameters["entity"] as! String, networkManager.parameters!["entity"] as! String)
    }

    func testGetPodcastsError() {
        let expectedError = NetworkError.descriptive(information: ErrorBuilder.errorInformation)
        setupTestData(error: expectedError)

        let searchTerm = ""
        let request = PodcastRequest(term: searchTerm)

        let expectation = XCTestExpectation(description: #function)
        sut.getPodcasts(request)
            .subscribe(onSuccess: { _ in
                XCTFail("testGetPodcastsError shouldn't succeed.")
            }, onFailure: { error in
                XCTAssertEqual(expectedError, error as! NetworkError)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        let expectedMethod = HttpVerb.get
        let expectedPath = Endpoint.endpointSearch
        let expectedParameters: [String: Any] = ["term": "",
                                                 "entity": "podcast"]

        XCTAssertEqual(expectedMethod, networkManager.method)
        XCTAssertEqual(expectedPath, networkManager.path)

        XCTAssertEqual(expectedParameters["term"] as! String, networkManager.parameters!["term"] as! String)
        XCTAssertEqual(expectedParameters["entity"] as! String, networkManager.parameters!["entity"] as! String)
    }

}
