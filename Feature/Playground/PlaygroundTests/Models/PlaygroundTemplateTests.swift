import XCTest
@testable import Playground

final class PlaygroundTemplateTests: XCTestCase {
	func testTheGitHubTemplateUsesTheCorrectSettingsAndContents() {
		let endpoint = URL(string: "https://api.github.com/graphql")!
		let template = Playground.Template.gitHub

		XCTAssertEqual(template.settings, Playground.Settings(endpoint: endpoint))
		XCTAssertEqual(template.contents, "\n")
		XCTAssertEqual(template.name, "GitHub")
	}
}
