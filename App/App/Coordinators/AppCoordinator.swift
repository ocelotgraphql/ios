import UIKit
import CommonUI
import PlaygroundBrowserUI

final class AppCoordinator: Coordinator {
	private let presenter: Presenter
	private var children = [Coordinator]()

	init(presenter: Presenter) {
		self.presenter = presenter
	}

	func start() {
		let playgroundBrowserCoordinator = PlaygroundBrowserCoordinator(presenter: presenter)
		children.append(playgroundBrowserCoordinator)
		playgroundBrowserCoordinator.start()
	}
}
