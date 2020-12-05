import UIKit

class PhotosCollectionView: UIView {
    private let constant: CGFloat = 0
    let layout = PinterestLayout()
    var collectionView: UICollectionView

    override init(frame: CGRect) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupViews()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
    }

    private func setupHierarchy() {
        self.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: constant),
            collectionView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: -constant),
            collectionView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: constant),
            collectionView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -constant)
        ])
        
    }
}
