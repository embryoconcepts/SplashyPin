import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var labelContainerView: UIView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configureCell(_ model: CellViewModel) {
        labelContainerView.backgroundColor = model.image.averageColor
        imageView.image = model.image

        if let description = model.description {
            labelContainerView.isHidden = false
            descriptionLabel.text = description
            descriptionLabel.textColor = labelContainerView.backgroundColor?.isDarkColor == true ? .white : .black
        } else {
            labelContainerView.isHidden = true
        }
    }
}
