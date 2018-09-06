import XCTest
@testable import UIImageCacheKit

class UIImageCacheKitTests: XCTestCase {
    class RecordingObserver: UIImageCacheObserver {
        var imageURL: ImageURL?
        var image: UIImage?
        var cachedCalled: Bool = false
        var failedCalled: Bool = false

        func cached(imageURL: ImageURL, image: UIImage) {
            self.cachedCalled = true
            self.imageURL = imageURL
            self.image = image
        }

        func failed(imageURL: ImageURL) {
            self.failedCalled = true
        }

        func wait() {
            while (self.cachedCalled == false && self.failedCalled == false) {
                sleep(1)
            }
        }
    }

// TODO: stub out the actual network request portion so that I can test the
// expected behaviors without having to worry about the an external service
// being up and providing the various urls and states.
//
//    func testPrimingAndFetchingAnImage() {
//        let url = ImageURL(string: "some-real-image-url")!
//
//        let observer = RecordingObserver()
//        let cache = UIImageCache()
//        cache.addObserver(observer)
//
//        cache.prime(imageURL: url)
//
//        observer.wait()
//
//        XCTAssert(observer.imageURL! == url)
//        XCTAssert(observer.image! == cache.fetch(imageURL: url)!)
//    }
//
//    func testNonExistingUrlToPrimeAnImage() {
//        let url = ImageURL(string: "some-non-existent-url")!
//        let observer = RecordingObserver()
//        let cache = UIImageCache()
//        cache.addObserver(observer)
//
//        cache.prime(imageURL: url)
//
//        observer.wait()
//
//        XCTAssert(observer.failedCalled == true)
//        XCTAssertNil(observer.imageURL)
//        XCTAssertNil(observer.image)
//    }
//
//    func testExistingUrlInvalidImagePrime() {
//        let url = ImageURL(string: "some-existent-url-but-is-not-an-image")!
//        let observer = RecordingObserver()
//        let cache = UIImageCache()
//        cache.addObserver(observer)
//
//        cache.prime(imageURL: url)
//
//        observer.wait()
//
//        XCTAssert(observer.failedCalled == true)
//        XCTAssertNil(observer.imageURL)
//        XCTAssertNil(observer.image)
//    }
}
