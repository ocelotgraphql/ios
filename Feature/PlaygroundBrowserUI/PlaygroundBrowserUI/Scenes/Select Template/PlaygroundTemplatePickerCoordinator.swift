import UIKit
import Common
import Playground
import CommonUI

protocol PlaygroundTemplatePickerCoordinatorDelegate: class {
	func playgroundTemplatePickerDidCancel(_ templatePicker: PlaygroundTemplatePickerCoordinator)
	func playgroundTemplatePicker(
		_ templatePicker: PlaygroundTemplatePickerCoordinator,
		didPick template: Playground.Template
	)
}

final class PlaygroundTemplatePickerCoordinator: Coordinator {
	weak var delegate: PlaygroundTemplatePickerCoordinatorDelegate?
	private let presenter: Presenter
	private var navigationController: UINavigationController?

	init(presenter: Presenter) {
		self.presenter = presenter
	}

	func start() {
		let pickerViewController = PlaygroundTemplatePickerViewController()
		pickerViewController.coordinatorDelegate = self
		pickerViewController.title = "Choose a Template"
		pickerViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(cancelButtonTapped)
		)
		let navigationController = UINavigationController(rootViewController: pickerViewController)
		navigationController.navigationBar.tintColor = .theme
		self.navigationController = navigationController
		presenter.present(navigationController, animated: true)
	}

	@objc private func cancelButtonTapped() {
		navigationController?.dismiss(animated: true) { [weak self] in
			guard let self = self else { return }
			self.delegate?.playgroundTemplatePickerDidCancel(self)
		}
	}
}

extension PlaygroundTemplatePickerCoordinator: PlaygroundTemplatePickerViewControllerDelegate {
	func templatePicker(_ templatePicker: PlaygroundTemplatePickerViewController, didPick template: Playground.Template) {
		navigationController?.dismiss(animated: true) { [weak self] in
			guard let self = self else { return }
			self.delegate?.playgroundTemplatePicker(self, didPick: template)
		}
	}
}
