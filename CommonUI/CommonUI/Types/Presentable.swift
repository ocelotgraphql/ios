import UIKit

/// A module that can be presented.
public protocol Presentable {
	/// Gets the `UIViewController` used to present the module.
	///
	/// - Returns: The `UIViewController` to be presented.
	func toPresent() -> UIViewController?
}
