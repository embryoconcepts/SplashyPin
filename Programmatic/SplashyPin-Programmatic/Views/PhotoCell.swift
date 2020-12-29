import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    private let stackViewConstant: CGFloat = 0
    private let labelConstant: CGFloat = 4

    private let imageView = UIImageView(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    private let labelContainerView = UIView(frame: .zero)
    private var stackView = UIStackView()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func update(with viewModel: PhotoCellViewModel) {
        labelContainerView.backgroundColor = viewModel.image.averageColor
        imageView.image = viewModel.image

        if let description = viewModel.description {
            labelContainerView.isHidden = false
            descriptionLabel.text = description
            descriptionLabel.textColor = labelContainerView.backgroundColor?.isDarkColor == true ? .white : .black
        } else {
            labelContainerView.isHidden = true
        }
    }

    private func setupViews() {
        [imageView, descriptionLabel, labelContainerView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        descriptionLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping

        labelContainerView.backgroundColor = .red

        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing

    }

    private func setupHierarchy() {
        labelContainerView.addSubview(descriptionLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelContainerView)
        contentView.addSubview(stackView)
    }

    private func setupLayout() {

        NSLayoutConstraint.activate([
            labelContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: labelConstant),
            descriptionLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor, constant: -labelConstant),
            descriptionLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: labelConstant),
            descriptionLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -labelConstant)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: stackViewConstant),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -stackViewConstant),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: stackViewConstant),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -stackViewConstant)
        ])

    }
}
