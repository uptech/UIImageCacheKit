import UIKit

public typealias ImageURL = URL

public protocol UIImageCacheObserver {
    /**
     * Successfully cached image identified by the given url
     */
    func cached(imageURL: ImageURL, image: UIImage)

    /**
     * Failed to cache the image identified by the url
     *
     * This is either because the provided image url doesn't exist, or the
     * data found at the given url isn't valide image data.
     */
    func failed(imageURL: ImageURL)
}

public class UIImageCache {
    class CacheImageRequest {
        let imageURL: ImageURL
        var image: UIImage?

        init(imageURL: ImageURL) {
            self.imageURL = imageURL
        }

        public func fetch(complete: ((ImageURL, UIImage?) -> ())? = nil) {
            DispatchQueue.global().async { [weak self] in
                if let s = self {
                    if let data = try? Data(contentsOf: s.imageURL) {
                        if let image = UIImage(data: data) {
                            self?.image = image
                            complete?(s.imageURL, image)
                        } else {
                            complete?(s.imageURL, nil)
                        }
                    } else {
                        complete?(s.imageURL, nil)
                    }
                }
            }
        }
    }

    private var images: [ImageURL: CacheImageRequest] = [:]
    private var observers: [WeakWrapper<UIImageCacheObserver>] = []

    public func prime(imageURL: ImageURL) {
        if images[imageURL] == nil {
            let cacheImageRequest = CacheImageRequest(imageURL: imageURL)
            images[imageURL] = cacheImageRequest
            cacheImageRequest.fetch(complete: { [weak self] (url, image) -> () in
                if let image = image {
                    self?.observers.forEach({ $0.value?.cached(imageURL: url, image: image) })
                } else {
                    self?.observers.forEach({ $0.value?.failed(imageURL: url) })
                }
            })
        }
    }

    public func fetch(imageURL: ImageURL) -> UIImage? {
        if let cacheImageRequest = images[imageURL] {
            return cacheImageRequest.image
        } else {
            let cacheImageRequest = CacheImageRequest(imageURL: imageURL)
            images[imageURL] = cacheImageRequest
            cacheImageRequest.fetch(complete: { [weak self] (url, image) -> () in
                if let image = image {
                    self?.observers.forEach({ $0.value?.cached(imageURL: url, image: image) })
                } else {
                    self?.observers.forEach({ $0.value?.failed(imageURL: url) })
                }
            })
            return cacheImageRequest.image
        }
    }

    public func addObserver(_ observer: UIImageCacheObserver) {
        self.observers.append(WeakWrapper(observer))
    }
}
