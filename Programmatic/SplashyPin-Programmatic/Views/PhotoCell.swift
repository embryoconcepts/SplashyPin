import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var labelContainerView: UIView!

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
}
