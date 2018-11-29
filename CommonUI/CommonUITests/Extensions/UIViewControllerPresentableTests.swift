import XCTest
@testable import CommonUI

final class UIViewControllerPresentableTests: XCTestCase {
	func testItIsThePresentableItself() {
		let viewController = UIViewController()

		XCTAssertTrue(viewController === viewController.toPresent())
	}
}
