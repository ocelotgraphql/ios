import UIKit
import Playground

protocol PlaygroundTemplatePickerViewControllerDelegate: class {
	func templatePicker(
		_ templatePicker: PlaygroundTemplatePickerViewController,
		didPick template: Playground.Template
	)
}

final class PlaygroundTemplatePickerViewController: UIViewController {
	weak var coordinatorDelegate: PlaygroundTemplatePickerViewControllerDelegate?

	private let templates = Array(Playground.Template.allCases.dropFirst())

	private lazy var templatesCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
		flowLayout.minimumLineSpacing = 16
		flowLayout.minimumInteritemSpacing = 16
		flowLayout.itemSize = CGSize(width: 100, height: 130)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.backgroundColor = .clear
		collectionView.register(PlaygroundTemplateCell.self, forCellWithReuseIdentifier: PlaygroundTemplateCell.identifier)
		collectionView.dataSource = self
		collectionView.delegate = self
		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		templatesCollectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(templatesCollectionView)
		activateConstraints()
	}

	private func activateConstraints() {
		NSLayoutConstraint.activate([
			templatesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			templatesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			templatesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			templatesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
}

extension PlaygroundTemplatePickerViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return templates.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: PlaygroundTemplateCell.identifier,
			for: indexPath
		) as! PlaygroundTemplateCell
		cell.template = templates[indexPath.item]
		return cell
	}
}

extension PlaygroundTemplatePickerViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let template = templates[indexPath.item]
		coordinatorDelegate?.templatePicker(self, didPick: template)
	}
}
