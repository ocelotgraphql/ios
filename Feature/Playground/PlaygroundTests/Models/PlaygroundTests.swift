import XCTest
@testable import Playground

final class PlaygroundTests: XCTestCase {
	private let contents = "query { hello }"
	private let settings = Playground.Settings(endpoint: URL(string: "https://api.example.com/graphql")!)

	func testItCreatesPlaygrounds() {
		let playgroundCreation = expectation(description: #function)

		let playgroundURL = randomTemporaryPlaygroundURL()
		let playground = Playground(fileURL: playgroundURL)
		var readPlayground: Playground?

		playground.contents = contents
		playground.settings = settings

		playground.save(to: playgroundURL, for: .forCreating) { _ in
			readPlayground = Playground(fileURL: playgroundURL)
			readPlayground?.open { _ in
				playgroundCreation.fulfill()
			}
		}

		waitForExpectations(timeout: 3)

		do {
			let subpaths = try FileManager.default.subpathsOfDirectory(atPath: playground.fileURL.relativeString)
			XCTAssertTrue(subpaths.contains(Playground.FileName.contents))
			XCTAssertTrue(subpaths.contains(Playground.FileName.settings))
		} catch {
			XCTFail(error.localizedDescription)
		}

		XCTAssertEqual(readPlayground?.contents, contents)
		XCTAssertEqual(readPlayground?.settings, settings)
	}

	func testItFailsToOpenPlaygroundsWithIncorrectFileFormat() {
		let playgroundOpening = expectation(description: #function)

		let playgroundURL = randomTemporaryPlaygroundURL()
		let playground = Playground(fileURL: playgroundURL)

		guard (try? Data().write(to: playgroundURL)) != nil else {
			XCTFail("Failed to write to \(playgroundURL)")
			return
		}

		playground.open { success in
			XCTAssertFalse(success)
			playgroundOpening.fulfill()
		}

		waitForExpectations(timeout: 1)
	}

	func testItUpdatesPlaygrounds() {
		let playgroundUpdating = expectation(description: #function)

		let playgroundURL = randomTemporaryPlaygroundURL()
		let playground = Playground(fileURL: playgroundURL)
		let updatedContents = "mutation { createUser }"
		let updatedSettings = Playground.Settings(endpoint: URL(string: "https://api.updatedexample.com/graphql")!)
		var readPlayground: Playground?

		playground.contents = contents
		playground.settings = settings

		playground.save(to: playgroundURL, for: .forCreating) { _ in
			playground.contents = updatedContents
			playground.settings = updatedSettings
			playground.save(to: playgroundURL, for: .forOverwriting) { _ in
				readPlayground = Playground(fileURL: playgroundURL)
				readPlayground?.open { _ in
					playgroundUpdating.fulfill()
				}
			}
		}

		waitForExpectations(timeout: 3)

		XCTAssertEqual(readPlayground?.contents, updatedContents)
		XCTAssertEqual(readPlayground?.settings, updatedSettings)
	}

	private func randomTemporaryPlaygroundURL() -> URL {
		let uuid = UUID().uuidString
		return URL(fileURLWithPath: "\(uuid).ocelotplayground")
	}
}
