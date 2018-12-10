import UIKit
import Playground

final class PlaygroundTemplateCell: UICollectionViewCell {
	static let identifier = String(describing: PlaygroundTemplateCell.self)

	var template: Playground.Template? {
		didSet {
			thumbnailView.image = template?.thumbnail
			nameLabel.text = template?.name
		}
	}

	private lazy var thumbnailView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.masksToBounds = true
		imageView.image = Playground.Template.gitHub.thumbnail
		return imageView
	}()

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .headline)
		label.text = Playground.Template.gitHub.name
		label.textAlignment = .center
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.layer.cornerRadius = 6
		contentView.layer.borderColor = UIColor.theme.withAlphaComponent(0.1).cgColor
		contentView.layer.borderWidth = 2

		for subview in [thumbnailView, nameLabel] {
			subview.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(subview)
		}
		activateConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		return nil
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		template = nil
	}

	private func activateConstraints() {
		NSLayoutConstraint.activate([
			thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
			thumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
			thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor),

			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
		])
	}
}
