import Common
import Playground
import UIKit
import CommonUI
import PlaygroundBrowserUI

final class AppCoordinator: Coordinator {
	private let presenter: Presenter
	private var secureStringStore: SecureStringStore
	private var children = [Coordinator]()

	init(presenter: Presenter, secureStringStore: SecureStringStore) {
		self.presenter = presenter
		self.secureStringStore = secureStringStore
	}

	func start() {
		startPlaygroundBrowser()
	}

	private func startPlaygroundBrowser() {
		let playgroundBrowserCoordinator = PlaygroundBrowserCoordinator(
			presenter: presenter,
			secureStringStore: secureStringStore
		)
		playgroundBrowserCoordinator.delegate = self
		children.append(playgroundBrowserCoordinator)
		playgroundBrowserCoordinator.start()
	}
}

extension AppCoordinator: PlaygroundBrowserCoordinatorDelegate {
	func playgroundBrowserCoordinator(
		_ coordinator: PlaygroundBrowserCoordinator,
		didOpen playground: Playground
	) {}
}
