@testable import MyHeritage
import RxSwift
import XCTest

class ListViewModelTests: XCTestCase {

    var sut: ListViewModel!

    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
        disposeBag = nil
    }

    // MARK: - Helpers
    private func setupTestData(mapper: PodcastItemMapper,
                               response: PodcastsResponse) {
        let podcastService = FakePodcastService(podcastsResponse: response)

        sut = ListViewModel(podcastItemMapper: mapper,
                            podcastService: podcastService)
    }

    // MARK: - Tests
    func testLoadPodcasts() {
        let mapper = PodcastItemMapper()
        let podcastsResponse = PodcastBuilder.podcastsResponse
        setupTestData(mapper: mapper,
                      response: podcastsResponse)

        let mappedItems = mapper(podcastsResponse)

        let expectation = XCTestExpectation(description: #function)

        sut.output.items
            .skip(1)
            .subscribe(onNext: { items in
                XCTAssertEqual(items, mappedItems)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.input.action.onNext(.loadPodcasts("Search"))

        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Tests
    func testSelectedItem() {
        let mapper = PodcastItemMapper()
        let podcastsResponse = PodcastBuilder.podcastsResponse
        setupTestData(mapper: mapper,
                      response: podcastsResponse)

        let mappedItems = mapper(podcastsResponse)
        let expectedMapItem = mappedItems[0]

        let expectation = XCTestExpectation(description: #function)
        let expectedDependencies = DetailsDependencies(item: expectedMapItem)

        sut.output.showDetailsScreen
            .subscribe(onNext: { dependecies in
                XCTAssertEqual(dependecies, expectedDependencies)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.input.action.onNext(.selectedItem(expectedMapItem))

        wait(for: [expectation], timeout: 1)
    }

}
