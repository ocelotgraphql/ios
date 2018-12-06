import XCTest
@testable import Common

final class URLSessionNetworkSessionTests: XCTestCase {
	private let testURL = URL(string: "https://test.com")!

	func testTheDataTaskMethodReturnsAURLSessionDataTask() {
		let request = URLRequest(url: testURL)
		let networkSession: NetworkSession = URLSession.shared
		let dataTask = networkSession.dataTask(with: request) { _, _, _ in }

		XCTAssertTrue(dataTask is URLSessionDataTask)
	}
}
