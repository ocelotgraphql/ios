import UIKit
import CommonUI

final class AppCoordinator: Coordinator {
	private let presenter: Presenter

	init(presenter: Presenter) {
		self.presenter = presenter
	}

	func start() {
		let viewController = UIViewController()
		viewController.view.backgroundColor = .white
		presenter.setRootModule(viewController, hideNavigationBar: true)
	}
}
