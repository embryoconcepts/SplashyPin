import UIKit

class PhotosCollectionViewController: UIViewController {

    // MARK: - Outlets

    // TODO: add to photosView
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    lazy var photosCollectionView = {
        return PhotosCollectionView()
    }()

    let collectionViewModel = PhotosCollectionViewModel(client: UnsplashClient())


    // MARK: - Lifecycle

    override func loadView() {
        view = photosCollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadPhotos()
    }


    // MARK: - Private functions

    private func setupViews() {
        photosCollectionView.collectionView.delegate = self
        photosCollectionView.collectionView.dataSource = self

        // collection view layout
        if let layout = photosCollectionView.collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        // pull to refresh
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(loadPhotos), for: .valueChanged)
        rc.tintColor = .clear
        photosCollectionView.collectionView.refreshControl = rc

        // navigation bar
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        refreshButton.tintColor = .white
        navigationItem.rightBarButtonItem = refreshButton

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemRed
        navigationItem.title = "SplashyPin"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue):
                UIFont(name: "AvenirNext-Bold", size: 35) as Any,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):
                UIColor.white
        ]
    }

    @objc private func loadPhotos() {
        photosCollectionView.collectionView.refreshControl?.endRefreshing()

        collectionViewModel.showLoading = {
            if self.collectionViewModel.isLoading {
                // TODO: add to photos view model
//                self.activityIndicator.startAnimating()
                self.photosCollectionView.collectionView.alpha = 0.0
            } else {
//                self.activityIndicator.stopAnimating()
                self.photosCollectionView.collectionView.alpha = 1.0
            }
        }

        collectionViewModel.showError = { error in
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

        collectionViewModel.reloadData = {
            self.photosCollectionView.collectionView.reloadData()
        }

        collectionViewModel.fetchPhotoMetadata()
    }

    @objc func refreshButtonTapped() {
        loadPhotos()
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegate {

}


// MARK: - Flow layout delegate

extension PhotosCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = collectionViewModel.cellViewModels[indexPath.item].image
        let height = image.size.height
        return height
    }
}


// MARK: - Data Source

extension PhotosCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.update(with: collectionViewModel.cellViewModels[indexPath.item])
        return cell
    }
}
