import UIKit
import Common
import CommonUI
import PlaygroundBrowserUI

final class AppCoordinator: Coordinator {
	private let presenter: Presenter
	private var secureStringStore: SecureStringStore
	private var children = [Coordinator]()

	init(presenter: Presenter, secureStringStore: inout SecureStringStore) {
		self.presenter = presenter
		self.secureStringStore = secureStringStore
	}

	func start() {
		let playgroundBrowserCoordinator = PlaygroundBrowserCoordinator(presenter: presenter)
		children.append(playgroundBrowserCoordinator)
		playgroundBrowserCoordinator.start()
	}
}
