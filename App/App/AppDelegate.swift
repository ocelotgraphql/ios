import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder {
	lazy var window: UIWindow? = {
		let window = UIWindow(frame: UIScreen.main.bounds)
		let viewController = UIViewController()
		viewController.view.backgroundColor = .white
		window.rootViewController = viewController
		return window
	}()
}

extension AppDelegate: UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		window?.makeKeyAndVisible()
		return true
	}
}
