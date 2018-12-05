import XCTest
@testable import Playground

final class PlaygroundBuilderTests: XCTestCase {
	func testItBuildsPlaygroundsWithTemporaryFileURLs() {
		let playground = Playground.Builder().build()

		XCTAssertTrue(playground.fileURL.absoluteString.contains(NSTemporaryDirectory()))
	}

	func testItBuildsPlaygroundsWithMeaningfulDefaults() {
		let playground = Playground.Builder().build()

		XCTAssertEqual(playground.settings, Playground.Settings())
		XCTAssertEqual(playground.contents, "\n")
	}

	func testItBuildsPlaygroundsWithChainedChanges() {
		let endpoint = URL(string: "https://test.com")!
		let contents = "{ test }"
		let playground = Playground.Builder()
			.withEndpoint(endpoint)
			.withDefaultContents(contents)
			.build()

		XCTAssertEqual(playground.settings.endpoint, endpoint)
		XCTAssertEqual(playground.contents, contents)
	}
}
