import UIKit

let imageCache = NSCache<NSString, UIImage>()

struct CellViewModel {
    let image: UIImage
    let description: String?
}

class ViewModel {

    // MARK: Properties

    private let client: APIClient
    private var photos: Photos = [] {
        didSet {
            self.fetchPhoto()
        }
    }
    var cellViewModels: [CellViewModel] = []


    // MARK: UI

    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }

    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?

    init(client: APIClient) {
        self.client = client
    }

    /// Fetch the metadata for a set of photos
    func fetchPhotoMetadata() {
        if let client = client as? UnsplashClient {
            self.isLoading = true
            let endpoint = UnsplashEndpoint.photos(id: UnsplashClient.apiKey, order: .popular)
            client.fetch(with: endpoint) { either in
                switch either {
                    case .success(let photos):
                        self.photos = photos
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }
    }

    /// Fetch the images for an array of Photos
    private func fetchPhoto() {
        let group = DispatchGroup()
        var finalImage = UIImage()

        for photo in photos {
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()

                imageCache.totalCostLimit = 50_000_000
                let imagePath = photo.urls.thumb

                if let imageFromCache = imageCache.object(forKey: imagePath.absoluteString as NSString) {
                    finalImage = imageFromCache
                } else {
                    guard let imageData = try? Data(contentsOf: imagePath) else {
                        self.showError!(APIError.imageDownload)
                        return
                    }

                    guard let image = UIImage(data: imageData) else {
                        self.showError!(APIError.imageConvert)
                        return
                    }

                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        imageCache.setObject(image, forKey: imagePath.absoluteString as NSString, cost: imageData.count)
                        finalImage = image
                    }
                }

                var description: String?
                if let desc = photo.description {
                    description = desc
                } else if let alt = photo.altDescription {
                    description = alt
                }

                self.cellViewModels.append(CellViewModel(image: finalImage, description: description))
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }
}
