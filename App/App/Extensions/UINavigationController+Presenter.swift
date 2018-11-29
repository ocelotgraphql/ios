import UIKit
import CommonUI

extension UINavigationController: Presenter {
	public func setRootModule(_ module: Presentable?, hideNavigationBar: Bool) {
		guard let viewController = module?.toPresent() else { return }
		setViewControllers([viewController], animated: false)
		navigationBar.isHidden = hideNavigationBar
	}
}
