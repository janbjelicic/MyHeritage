@testable import MyHeritage
import RxSwift
import XCTest

class DetailsViewModelTests: XCTestCase {

    var sut: DetailsViewModel!

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
    private func setupTestData(dependencies: DetailsDependencies) {

        sut = DetailsViewModel(dependencies: dependencies)
    }

    // MARK: - Tests
    func testInitialState() {
        let podcastItem = PodcastBuilder.podcastItem
        let dependencies = DetailsDependencies(item: podcastItem)

        setupTestData(dependencies: dependencies)

        sut.output.podcastImage
            .subscribe(onNext: { image in
                XCTAssertEqual(image, dependencies.item.podcastImage)
            })
            .disposed(by: disposeBag)

        sut.output.artist
            .subscribe(onNext: { text in
                XCTAssertEqual(text, dependencies.item.artist)
            })
            .disposed(by: disposeBag)

        sut.output.track
            .subscribe(onNext: { text in
                XCTAssertEqual(text, dependencies.item.track)
            })
            .disposed(by: disposeBag)

        sut.output.releaseDate
            .subscribe(onNext: { text in
                XCTAssertEqual(text, dependencies.item.releaseDate)
            })
            .disposed(by: disposeBag)
    }

}
