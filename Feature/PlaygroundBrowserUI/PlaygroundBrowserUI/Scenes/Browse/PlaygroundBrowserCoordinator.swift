import UIKit
import CommonUI

public final class PlaygroundBrowserCoordinator: Coordinator {
	private let presenter: Presenter

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
		didRequestPlaygroundCreationWithImportHandler importHandler: @escaping (
			URL?, UIDocumentBrowserViewController.ImportMode
		) -> Void
	) {
		// TODO: - Start CreatePlaygroundCoordinator
		importHandler(nil, .none)
	}
}
