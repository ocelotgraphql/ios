import Foundation

extension Playground {
	/// Build a `Playground` by chaining calls to methods preceeded by
	/// `with` and calling `build()` at the end. The `Playground`'
	/// will be assigned a generated, UUID-based, file name and its `fileURL`
	/// points to the users temporary directory.
	///
	/// - Warning: Building a `Playground` **will not store the Playground** at its
	/// generated `fileURL`. You can do so by manually calling `save(to:,for:,completionHandler:)`
	/// on the returned `Playground`.
	public final class Builder {
		private var settings: Settings
		private var contents: String

		/// Create a new `Playground.Builder` from the given template.
		///
		/// - Parameter template: Provides the default settings and contents.
		/// It defaults to `Playground.Template.empty`.
		public init(from template: Template = .empty) {
			self.settings = template.settings
			self.contents = template.contents
		}

		/// Assign an `endpoint` to the playground being built.
		///
		/// - Note: Remeber to call `build()` at the end of the chain.
		/// - Parameter endpoint: The `Playground`s endpoint.
		/// - Returns: The `Playground.Builder` instance that's currently building. (`self`)
		public func withEndpoint(_ endpoint: URL) -> Builder {
			settings = Settings(endpoint: endpoint)
			return self
		}

		/// Assign contents to the playground being built.
		///
		/// - Note: Remeber to call `build()` at the end of the chain.
		/// - Parameter contents: The `Playground`s contents.
		/// - Returns: The `Playground.Builder` instance that's currently building. (`self`)
		public func withDefaultContents(_ contents: String) -> Builder {
			self.contents = contents
			return self
		}

		/// By calling this method on the end of your call chain
		/// the `Playground.Builder` creates a new `Playground` instance by applying
		/// all previously chained changes.
		///
		/// - Returns: The built `Playground`.
		public func build() -> Playground {
			let playgroundURL = generateTemporaryPlaygroundURL()
			let playground = Playground(fileURL: playgroundURL)
			playground.settings = settings
			playground.contents = contents
			return playground
		}

		private func generateTemporaryPlaygroundURL() -> URL {
			let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
			let uuidString = UUID().uuidString
			return temporaryDirectoryURL.appendingPathComponent("\(uuidString).ocelotplayground")
		}
	}
}
