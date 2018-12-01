import UIKit
import CommonUI

public final class PlaygroundBrowserCoordinator: Coordinator {
	private let presenter: Presenter

	private lazy var browserViewController = PlaygroundBrowserViewController()

	public init(presenter: Presenter) {
		self.presenter = presenter
	}

	public func start() {
		presenter.setRootModule(browserViewController, hideNavigationBar: true)
	}
}
