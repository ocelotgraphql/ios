import UIKit
import CommonUI
import Playground

typealias PlaygroundCreationImportHandler = (URL?, UIDocumentBrowserViewController.ImportMode) -> Void

protocol PlaygroundCreationCoordinatorDelegate: class {
	func playgroundCreationCoordinatorDidCancel(_ coordinator: PlaygroundCreationCoordinator)
}

final class PlaygroundCreationCoordinator: Coordinator {
	weak var delegate: PlaygroundCreationCoordinatorDelegate?

	private let presenter: Presenter
	private let importHandler: PlaygroundCreationImportHandler
	private var selectedTemplate: Playground.Template?

	private lazy var navigationController: UINavigationController = {
		let navigationController = UINavigationController(rootViewController: UIViewController())
		navigationController.navigationBar.tintColor = .theme
		return navigationController
	}()

	private lazy var templatePickerViewController: PlaygroundTemplatePickerViewController = {
		let viewController = PlaygroundTemplatePickerViewController()
		viewController.navigationItem.title = "Choose a template"
		let cancelItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(cancelButtonTapped)
		)
		viewController.navigationItem.leftBarButtonItem = cancelItem
		viewController.coordinatorDelegate = self
		return viewController
	}()

	private lazy var templateAuthTokenViewController: PlaygroundTemplateAuthTokenViewController = {
		let viewController = PlaygroundTemplateAuthTokenViewController()
		let createItem = UIBarButtonItem(
			title: "Create",
			style: .done,
			target: self,
			action: #selector(createButtonTapped)
		)
		createItem.isEnabled = false
		viewController.navigationItem.rightBarButtonItem = createItem
		viewController.authTokenDidChange = { authToken in
			createItem.isEnabled = !authToken.isEmpty
		}
		return viewController
	}()

	init(presenter: Presenter, importHandler: @escaping PlaygroundCreationImportHandler) {
		self.presenter = presenter
		self.importHandler = importHandler
	}

	func start() {
		presentTemplatePicker()
	}

	private func presentTemplatePicker() {
		navigationController.setViewControllers([templatePickerViewController], animated: false)
		presenter.present(navigationController, animated: true)
	}

	@objc private func cancelButtonTapped() {
		importHandler(nil, .none)
		navigationController.dismiss(animated: true) { [weak self] in
			guard let `self` = self else { return }
			self.delegate?.playgroundCreationCoordinatorDidCancel(self)
		}
	}

	@objc private func createButtonTapped() {
		navigationController.dismiss(animated: true) { [weak self] in
			guard let `self` = self, let selectedTemplate = self.selectedTemplate else { return }
			let playground = Playground.Builder(from: selectedTemplate).build()
			playground.save(to: playground.fileURL, for: .forCreating) { success in
				if success {
					self.importHandler(playground.fileURL, .move)
				} else {
					self.importHandler(nil, .none)
				}
			}
		}
	}
}

extension PlaygroundCreationCoordinator: PlaygroundTemplatePickerViewControllerCoordinatorDelegate {
	func playgroundTemplatePickerViewController(
		_ viewController: PlaygroundTemplatePickerViewController,
		didSelectTemplate selectedTemplate: Playground.Template
	) {
		self.selectedTemplate = selectedTemplate
		templateAuthTokenViewController.navigationItem.title = "Configure \(selectedTemplate.name)"
		navigationController.pushViewController(templateAuthTokenViewController, animated: true)
	}
}
