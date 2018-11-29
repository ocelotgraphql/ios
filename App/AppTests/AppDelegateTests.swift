import XCTest
@testable import App

final class AppDelegateTests: XCTestCase {
	func testItProvidesAKeyWindow() {
		let appDelegate = AppDelegate()
		let application = UIApplication.shared

		XCTAssertNil(application.keyWindow)

		let launched = appDelegate.application(application, didFinishLaunchingWithOptions: nil)

		XCTAssertTrue(launched)
		XCTAssertNotNil(appDelegate.window)
		XCTAssertEqual(application.keyWindow, appDelegate.window)
	}
}
