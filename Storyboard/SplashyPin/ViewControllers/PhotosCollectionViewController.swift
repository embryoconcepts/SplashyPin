import UIKit

class PhotosCollectionViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    let viewModel = ImageViewModel(client: UnsplashClient())


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadPhotos()
    }


    // MARK: - Private functions

    private func setupViews() {
        // collection view layout
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        // pull to refresh
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(loadPhotos), for: .valueChanged)
        rc.tintColor = .clear
        collectionView.refreshControl = rc

        // navigation bar
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        refreshButton.tintColor = .white
        navigationItem.rightBarButtonItem = refreshButton
    }

    @objc private func loadPhotos() {
        collectionView.refreshControl?.endRefreshing()

        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
                self.collectionView.alpha = 0.0
            } else {
                self.activityIndicator.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }

        viewModel.showError = { error in
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

        viewModel.reloadData = {
            self.collectionView.reloadData()
        }

        viewModel.fetchPhotoMetadata()
    }

    @objc func refreshButtonTapped() {
        loadPhotos()
    }
}


// MARK: - Flow layout delegate

extension PhotosCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.cellViewModels[indexPath.item].image
        let height = image.size.height
        return height
    }
}


// MARK: - Data Source

extension PhotosCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        cell.update(with: viewModel.cellViewModels[indexPath.item])
        return cell
    }
}