import Playground
import UIKit
import CommonUI

public protocol PlaygroundEditorCoordinatorDelegate: class {
	func playgroundEditorCoordinator(_ editor: PlaygroundEditorCoordinator, didClose playground: Playground)
}

public final class PlaygroundEditorCoordinator: Coordinator {
	public weak var delegate: PlaygroundEditorCoordinatorDelegate?

	private let playground: Playground
	private let presenter: Presenter

	private lazy var navigationController: UINavigationController = {
		let editorViewController = PlaygroundEditorViewController(editing: playground)
		editorViewController.title = "Playground"
		editorViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .save,
			target: self,
			action: #selector(saveButtonTapped)
		)
		let navigationController = UINavigationController(rootViewController: editorViewController)
		navigationController.navigationBar.tintColor = .theme
		return navigationController
	}()

	public init(editing playground: Playground, presentedBy presenter: Presenter) {
		self.playground = playground
		self.presenter = presenter
	}

	public func start() {
		presenter.present(navigationController, animated: true)
	}

	@objc private func saveButtonTapped() {
		playground.close { [weak self] _ in
			self?.navigationController.dismiss(animated: true) {
				guard let self = self else { return }
				self.delegate?.playgroundEditorCoordinator(self, didClose: self.playground)
			}
		}
	}
}
