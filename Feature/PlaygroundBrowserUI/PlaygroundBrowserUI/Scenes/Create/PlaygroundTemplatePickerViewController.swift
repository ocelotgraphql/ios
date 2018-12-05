import UIKit
import Playground

protocol PlaygroundTemplatePickerViewControllerCoordinatorDelegate: class {
	func playgroundTemplatePickerViewController(
		_ viewController: PlaygroundTemplatePickerViewController,
		didSelectTemplate selectedTemplate: Playground.Template
	)
}

final class PlaygroundTemplatePickerViewController: UIViewController {
	weak var coordinatorDelegate: PlaygroundTemplatePickerViewControllerCoordinatorDelegate?

	// Drop the empty template because it's not yet supported.
	private let templates = Array(Playground.Template.allCases.dropFirst())

	private lazy var collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.itemSize = CGSize(width: 100, height: 130)
		flowLayout.minimumInteritemSpacing = 32
		flowLayout.minimumLineSpacing = 32
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.backgroundColor = .clear
		collectionView.register(
			PlaygroundTemplatePreviewCell.self,
			forCellWithReuseIdentifier: PlaygroundTemplatePreviewCell.identifier
		)
		collectionView.dataSource = self
		collectionView.delegate = self
		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)

		activateConstraints()
	}

	private func activateConstraints() {
		let spacing: CGFloat = 32

		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing)
		])
	}
}

extension PlaygroundTemplatePickerViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return templates.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let template = templates[indexPath.item]
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: PlaygroundTemplatePreviewCell.identifier,
			for: indexPath
		) as! PlaygroundTemplatePreviewCell
		cell.template = template
		return cell
	}
}

extension PlaygroundTemplatePickerViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedTemplate = templates[indexPath.item]
		coordinatorDelegate?.playgroundTemplatePickerViewController(self, didSelectTemplate: selectedTemplate)
	}
}
