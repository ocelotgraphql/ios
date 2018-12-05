import Foundation

extension Playground {
	/// A `Playground.Template` provides the basis of which new
	/// `Playground`s are created.
	public struct Template {
		/// The `Playground`s settings.
		public let settings: Settings

		/// The `Playground`s contents.
		public let contents: String

		/// The default template with default settings and an empty new line as contents.
		public static let `default` = Template()

		/// A `Playground.Template` for GitHubs GraphQL API.
		public static let gitHub: Template = {
			let endpoint = URL(string: "https://api.github.com/graphql")!
			let settings = Settings(endpoint: endpoint)
			return Template(settings: settings)
		}()

		private init(settings: Settings = Settings(), contents: String = "\n") {
			self.settings = settings
			self.contents = contents
		}
	}
}
