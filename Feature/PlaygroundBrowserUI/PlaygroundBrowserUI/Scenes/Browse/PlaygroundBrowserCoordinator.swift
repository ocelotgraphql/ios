import UIKit
import CommonUI

public final class PlaygroundBrowserCoordinator: Coordinator {
	private let presenter: Presenter

	private var children = [Coordinator]()

	private lazy var browserViewController: PlaygroundBrowserViewController = {
		let viewController = PlaygroundBrowserViewController()
		viewController.coordinatorDelegate = self
		return viewController
	}()

	public init(presenter: Presenter) {
		self.presenter = presenter
	}

	public func start() {
		presenter.setRootModule(browserViewController, hideNavigationBar: true)
	}
}

extension PlaygroundBrowserCoordinator: PlaygroundBrowserViewControllerCoordinatorDelegate {
	func playgroundBrowserViewController(
		_ viewController: PlaygroundBrowserViewController,
		didRequestPlaygroundCreationWithImportHandler importHandler: @escaping PlaygroundCreationImportHandler
	) {
		let creationCoordinator = PlaygroundCreationCoordinator(presenter: presenter, importHandler: importHandler)
		creationCoordinator.delegate = self
		children.append(creationCoordinator)
		creationCoordinator.start()
	}
}

extension PlaygroundBrowserCoordinator: PlaygroundCreationCoordinatorDelegate {
	func playgroundCreationCoordinatorDidCancel(_ coordinator: PlaygroundCreationCoordinator) {
		guard let index = children.firstIndex(where: { $0 === coordinator }) else { return }
		children.remove(at: index)
	}
}
