import UIKit

class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    let viewModel = ViewModel(client: UnsplashClient())

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(loadPhotos), for: .valueChanged)
        rc.tintColor = .clear
        collectionView.refreshControl = rc

        setupNavigationBar()

        loadPhotos()


    }

    private func setupNavigationBar() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        refreshButton.tintColor = .white
        navigationItem.rightBarButtonItem = refreshButton
    }

    @objc private func loadPhotos() {
        collectionView.refreshControl?.endRefreshing()
        // Init viewModel
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
            // TODO: show alert
            print(error)
        }

        viewModel.reloadData = {
            self.collectionView.reloadData()
        }

        viewModel.fetchPhotos()
    }

    @objc func refreshButtonTapped() {
        loadPhotos()
    }
}

// MARK: Flow layout delegate

extension ViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.cellViewModels[indexPath.item].image
        let height = image.size.height
        return height
    }
}

// MARK: Data Source

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configureCell(viewModel.cellViewModels[indexPath.item])
        return cell
    }


}
