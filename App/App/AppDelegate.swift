import UIKit
import Common
import CommonUI

final class AppDelegate: UIResponder {
	private lazy var presenter: Presenter & Presentable = {
		let navigationController = UINavigationController(rootViewController: UIViewController())
		return navigationController
	}()

	private var keychain: SecureStringStore = Keychain()

	private lazy var coordinator: Coordinator = AppCoordinator(presenter: presenter, secureStringStore: &keychain)

	lazy var window: UIWindow? = {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = presenter.toPresent()
		return window
	}()
}

extension AppDelegate: UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		window?.makeKeyAndVisible()
		coordinator.start()
		return true
	}
}
