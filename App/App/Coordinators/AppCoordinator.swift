import Common
import Playground
import UIKit
import CommonUI
import PlaygroundBrowserUI
import EditorUI

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

	private func startEditor(for playground: Playground) {
		let playgroundEditorCoordinator = PlaygroundEditorCoordinator(
			editing: playground,
			presentedBy: presenter
		)
		children.append(playgroundEditorCoordinator)
		playgroundEditorCoordinator.start()
	}

	private func remove(_ child: Coordinator) {
		guard let index = children.firstIndex(where: { $0 === child }) else { return }
		children.remove(at: index)
	}
}

extension AppCoordinator: PlaygroundBrowserCoordinatorDelegate {
	func playgroundBrowserCoordinator(
		_ coordinator: PlaygroundBrowserCoordinator,
		didOpen playground: Playground
	) {
		startEditor(for: playground)
	}
}

extension AppCoordinator: PlaygroundEditorCoordinatorDelegate {
	func playgroundEditorCoordinator(
		_ editor: PlaygroundEditorCoordinator,
		didClose playground: Playground
	) {
		remove(editor)
	}
}
