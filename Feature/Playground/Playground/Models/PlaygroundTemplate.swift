import Foundation

extension Playground {
	/// A `Playground.Template` provides the defaults settings and contents for new `Playground`s.
	public enum Template {
		case empty
		case gitHub

		/// The `Playground`s settings.
		public var settings: Settings {
			switch self {
			case .empty:
				return Settings()
			case .gitHub:
				return Settings(endpoint: URL(string: "https://api.github.com/graphql")!)
			}
		}

		/// The `Playground`s contents.
		public var contents: String {
			return "\n"
		}
	}
}
