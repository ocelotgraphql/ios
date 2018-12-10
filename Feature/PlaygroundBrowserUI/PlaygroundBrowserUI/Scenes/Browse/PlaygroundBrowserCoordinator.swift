import UIKit
import Common
import Playground
import CommonUI

public protocol PlaygroundBrowserCoordinatorDelegate: Coordinator {
	func playgroundBrowserCoordinator(_ coordinator: PlaygroundBrowserCoordinator, didOpen playground: Playground)
}

public final class PlaygroundBrowserCoordinator: Coordinator {
	public weak var delegate: PlaygroundBrowserCoordinatorDelegate?

	private let presenter: Presenter
	private let secureStringStore: SecureStringStore
	private let gitHubPersonalAccessTokenService = "com.ocelotgraphql.ios.github-personal-access-token"
	private var gitHubPersonalAccessToken: String?
	private var playgroundToOpen: Playground?

	private var children = [Coordinator]()

	private lazy var browserViewController: PlaygroundBrowserViewController = {
		let viewController = PlaygroundBrowserViewController()
		viewController.coordinatorDelegate = self
		return viewController
	}()

	private var accessTokenNavigationController: UINavigationController?

	public init(presenter: Presenter, secureStringStore: SecureStringStore) {
		self.presenter = presenter
		self.secureStringStore = secureStringStore
	}

	public func start() {
		presenter.setRootModule(browserViewController, hideNavigationBar: true)
	}

	private func remove(_ child: Coordinator) {
		guard let coordinatorIndex = children.firstIndex(where: { $0 === child }) else { return }
		children.remove(at: coordinatorIndex)
	}

	@objc private func accessTokenDoneButtonTapped() {
		guard let accessToken = gitHubPersonalAccessToken, let playground = playgroundToOpen else { return }
		secureStringStore[gitHubPersonalAccessTokenService] = accessToken
		playground.additionalRequestHeaders["Authorization"] = "bearer \(accessToken)"
		accessTokenNavigationController?.dismiss(animated: true) { [weak self] in
			guard let self = self else { return }
			self.delegate?.playgroundBrowserCoordinator(self, didOpen: playground)
		}
	}
}

extension PlaygroundBrowserCoordinator: PlaygroundBrowserViewControllerDelegate {
	func playgroundBrowserDidRequestPlaygroundCreation(_ playgroundBrowser: PlaygroundBrowserViewController) {
		let templatePickerCoordinator = PlaygroundTemplatePickerCoordinator(presenter: presenter)
		templatePickerCoordinator.delegate = self
		children.append(templatePickerCoordinator)
		templatePickerCoordinator.start()
	}

	func playgroundBrowser(_ playgroundBrowser: PlaygroundBrowserViewController, didOpen playground: Playground) {
		if playground.settings.endpoint == Playground.Template.gitHub.settings.endpoint {
			if let token = secureStringStore[gitHubPersonalAccessTokenService] {
				playground.additionalRequestHeaders["Authorization"] = "bearer \(token)"
				delegate?.playgroundBrowserCoordinator(self, didOpen: playground)
			} else {
				playgroundToOpen = playground
				let accessTokenViewController = PlaygroundAccessTokenViewController()
				accessTokenViewController.coordinatorDelegate = self
				accessTokenViewController.navigationItem.title = "GitHub Authentication"
				accessTokenViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
					barButtonSystemItem: .save,
					target: self,
					action: #selector(accessTokenDoneButtonTapped)
				)
				let navigationController = UINavigationController(rootViewController: accessTokenViewController)
				navigationController.navigationBar.tintColor = .theme
				self.accessTokenNavigationController = navigationController
				presenter.present(navigationController, animated: true)
			}
		}
	}
}

extension PlaygroundBrowserCoordinator: PlaygroundTemplatePickerCoordinatorDelegate {
	func playgroundTemplatePickerDidCancel(_ templatePicker: PlaygroundTemplatePickerCoordinator) {
		remove(templatePicker)
		browserViewController.cancelPlaygroundCreation()
	}

	func playgroundTemplatePicker(
		_ templatePicker: PlaygroundTemplatePickerCoordinator,
		didPick template: Playground.Template
	) {
		remove(templatePicker)
		browserViewController.createPlayground(from: template)
	}
}

extension PlaygroundBrowserCoordinator: PlaygroundAccessTokenViewControllerDelegate {
	func accessTokenViewController(
		_ accessTokenViewController: PlaygroundAccessTokenViewController,
		accessTokenDidChange accessToken: String
	) {
		self.gitHubPersonalAccessToken = accessToken
	}
}
