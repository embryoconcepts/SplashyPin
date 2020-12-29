import UIKit

class PhotosCollectionView: UIView {
    private let collectionViewConstant: CGFloat = 8
    private let stackViewConstant: CGFloat = 16

    let layout = PinterestLayout()
    var collectionView: UICollectionView
    var activityStackView = UIStackView()
    var indicator = UIActivityIndicatorView()
    var loadingLabel = UILabel()

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
        [collectionView, loadingLabel, indicator, activityStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.backgroundColor = .white

        loadingLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
        loadingLabel.text = "Loading..."

        indicator.style = .large
        indicator.color = .systemRed

        activityStackView.axis = .vertical
        activityStackView.alignment = .center
        activityStackView.distribution = .fill
    }

    private func setupHierarchy() {
        activityStackView.addArrangedSubview(loadingLabel)
        activityStackView.addArrangedSubview(indicator)

        self.addSubview(activityStackView)
        self.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: collectionViewConstant),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -collectionViewConstant),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: collectionViewConstant),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -collectionViewConstant)
        ])
        
    }
}
