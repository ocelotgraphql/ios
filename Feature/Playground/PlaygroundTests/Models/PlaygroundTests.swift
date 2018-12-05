import XCTest
@testable import Playground

final class PlaygroundTests: XCTestCase {
	private let contents = "query { hello }"
	private let settings = Playground.Settings(endpoint: URL(string: "https://api.example.com/graphql")!)
	var createdPlaygroundURL: URL?

	override func tearDown() {
		super.tearDown()
		createdPlaygroundURL.flatMap(removeTemporaryPlayground)
	}

	func testItLoads() {
		let loading = expectation(description: #function)
		var successFullyOpenedPlayground = false

		createTemporaryPlayground { playgroundURL in
			let playground = Playground(fileURL: playgroundURL)
			playground.open { success in
				successFullyOpenedPlayground = success
				loading.fulfill()
			}
		}

		waitForExpectations(timeout: 3)

		XCTAssertTrue(successFullyOpenedPlayground)
	}

	func testItFailsToLoadMalformedFiles() {
		let loading = expectation(description: #function)
		var successFullyOpenedPlayground = false

		createTemporaryMalformedPlayground { playgroundURL in
			let playground = Playground(fileURL: playgroundURL)
			playground.open { success in
				successFullyOpenedPlayground = success
				loading.fulfill()
			}
		}

		waitForExpectations(timeout: 3)

		XCTAssertFalse(successFullyOpenedPlayground)
	}

	func testItSavesUpdates() {
		let updating = expectation(description: #function)
		let updatedContents = "{ test }"
		let updatedSettings = Playground.Settings(endpoint: URL(string: "https://test.com")!)
		var successFullyUpdatedPlayground = false
		var playground: Playground!

		createTemporaryPlayground { playgroundURL in
			playground = Playground(fileURL: playgroundURL)
			playground.settings = updatedSettings
			playground.contents = updatedContents
			playground.save(to: playgroundURL, for: .forOverwriting) { success in
				successFullyUpdatedPlayground = success
				updating.fulfill()
			}
		}

		waitForExpectations(timeout: 3)

		XCTAssertTrue(successFullyUpdatedPlayground)
		XCTAssertEqual(playground.settings, updatedSettings)
		XCTAssertEqual(playground.contents, updatedContents)
	}

	private func createTemporaryPlayground(then complete: @escaping (URL) -> Void) {
		let playground = Playground.Builder().build()
		playground.save(to: playground.fileURL, for: .forCreating) { [weak self] success in
			guard success else {
				XCTFail(#function)
				return
			}
			self?.createdPlaygroundURL = playground.fileURL
			complete(playground.fileURL)
		}
	}

	private func createTemporaryMalformedPlayground(then complete: @escaping (URL) -> Void) {
		let data = Data()
		let url = URL(fileURLWithPath: NSTemporaryDirectory())
			.appendingPathComponent("malformed.ocelotplayground")
		do {
			try data.write(to: url)
			complete(url)
		} catch {
			XCTFail(#function)
		}
	}

	private func removeTemporaryPlayground(at url: URL) {
		try? FileManager.default.removeItem(at: url)
	}
}
