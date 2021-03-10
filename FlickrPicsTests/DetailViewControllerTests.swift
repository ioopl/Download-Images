import XCTest
@testable import FlickrPics

class DetailViewControllerTests: XCTestCase {

    var detailViewController: DetailViewController!
    
    override func setUpWithError() throws {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            detailViewController = storyBoard.instantiateViewController(identifier: "DetailViewController")
            detailViewController.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testViewControllerHasRootView() {
        XCTAssertNotNil(detailViewController.view)
    }
    
    func testViewControllerHasChildView() {
        XCTAssertNotNil(detailViewController.detailDescriptionLabel)
        XCTAssertNotNil(detailViewController.imageView)
    }
    
    func testDetailItemUpdatesDetailDescriptionLabel() {
        let photo = Photo(id: "1", title: "photo", thumbnailUrl: "", fullSizeUrl: "")
        detailViewController.detailItem = photo
        XCTAssertEqual(detailViewController.detailDescriptionLabel.text, detailViewController.detailItem?.title)

    }
    
    //Testing configureView
    func testSettingDetailItemInitiatesDownload() {

        let photo = Photo(id: "1", title: "photo", thumbnailUrl: "https://www.google.com/1", fullSizeUrl: "https://www.google.com/2")
        
        // Because this property gets instantiated before
        let imageFetcher = MockImageFetcher()
        detailViewController.imageFetcher = imageFetcher
        
        
        detailViewController.detailItem = photo
        
        XCTAssertTrue(imageFetcher.downloadCalled)
        
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        detailViewController = nil
    }
}

class MockImageFetcher: ImageFetcherType {
    var downloadCalled = false
    func downloadImage(from url: URL, withCompletion completionHandler: @escaping ImageResponseHandler) {
       
        // Just a property to test if it's being called. 
        downloadCalled = true
    }
}
