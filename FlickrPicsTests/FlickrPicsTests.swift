import XCTest
@testable import FlickrPics

class FlickrPicsTests: XCTestCase {

    func testRecentsFetcher_callActualService_returnsResults() {
        let expectation = XCTestExpectation(description: "Result returned")
        let fetcher = RecentsFetcher()

        fetcher.fetchRecents(withCompletion: { (response) in
            guard case .Recents(let recents) = response else {
                XCTFail()
                return
            }
            XCTAssert(recents.count == 100)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }

}
