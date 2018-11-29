import XCTest
@testable import App

final class UINavigationControllerPresenterTests: XCTestCase {
	var oldRootViewController: UIViewController!
	var newRootViewController: UIViewController!
	var navigationController: UINavigationController!

	override func setUp() {
		super.setUp()
		oldRootViewController = UIViewController()
		newRootViewController = UIViewController()
		navigationController = UINavigationController(rootViewController: oldRootViewController)
	}

	func testItSetsTheRootModule() {
		navigationController.setRootModule(newRootViewController, hideNavigationBar: false)

		XCTAssertTrue(navigationController.viewControllers.first === newRootViewController)
	}

	func testItHidesTheNavigationBarAfterSettingTheRootModule() {
		navigationController.setRootModule(newRootViewController, hideNavigationBar: true)

		XCTAssertTrue(navigationController.navigationBar.isHidden)
	}

	func testItShowsTheNavigationBarAfterSettingTheRootModule() {
		navigationController.setRootModule(newRootViewController, hideNavigationBar: false)

		XCTAssertFalse(navigationController.navigationBar.isHidden)
	}

	func testItDoesNotChangeTheRootModuleIfTheGivenModuleIsNil() {
		navigationController.setRootModule(nil, hideNavigationBar: false)

		XCTAssertTrue(navigationController.viewControllers.first === oldRootViewController)
	}
}
