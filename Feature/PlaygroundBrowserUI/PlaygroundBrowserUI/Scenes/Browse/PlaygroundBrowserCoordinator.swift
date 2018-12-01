import UIKit
import CommonUI

public final class PlaygroundBrowserCoordinator: Coordinator {
	private let presenter: Presenter

	public init(presenter: Presenter) {
		self.presenter = presenter
	}

	public func start() {
		let viewController = UIViewController()
		viewController.view.backgroundColor = .white
		presenter.setRootModule(viewController, hideNavigationBar: true)
	}
}
