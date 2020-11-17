import UIKit

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

    func fetchPhotos() {
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

    private func fetchPhoto() {
        let group = DispatchGroup()
        for photo in photos {
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                guard let imageData = try? Data(contentsOf: photo.urls.thumb) else {
                    self.showError!(APIError.imageDownload)
                    return
                }

                guard let image = UIImage(data: imageData) else {
                    self.showError!(APIError.imageConvert)
                    return
                }

                var description: String?
                if let desc = photo.description {
                    description = desc
                } else if let alt = photo.altDescription {
                    description = alt
                }

                self.cellViewModels.append(CellViewModel(image: image, description: description))
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }
}
