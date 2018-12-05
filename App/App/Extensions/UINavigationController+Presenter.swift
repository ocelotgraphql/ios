import UIKit
import CommonUI

extension UINavigationController: Presenter {
	public func setRootModule(_ module: Presentable?, hideNavigationBar: Bool) {
		guard let viewController = module?.toPresent() else { return }
		setViewControllers([viewController], animated: false)
		navigationBar.isHidden = hideNavigationBar
	}

	public func present(_ module: Presentable?, animated: Bool) {
		guard let viewController = module?.toPresent() else { return }
		present(viewController, animated: animated)
	}
}
