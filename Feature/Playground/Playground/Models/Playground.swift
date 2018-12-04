import UIKit

/// `UIDocument` subclass used to manage `.ocelotplayground` files.
public final class Playground: UIDocument {
	/// Contents of the playgrounds `contents.graphql` file.
	public var contents = "" {
		didSet {
			guard contents != oldValue else { return }

			if let contentsFileWrapper = packageFileWrapper.fileWrappers?[FileName.contents] {
				packageFileWrapper.removeFileWrapper(contentsFileWrapper)
			}
		}
	}

	/// `Settings` stored inside the playgrounds `settings.json` file.
	public var settings = Settings(endpoint: nil) {
		didSet {
			guard settings != oldValue else { return }

			if let settingsFileWrapper = packageFileWrapper.fileWrappers?[FileName.settings] {
				packageFileWrapper.removeFileWrapper(settingsFileWrapper)
			}
		}
	}

	private lazy var jsonEncoder = JSONEncoder()
	private lazy var jsonDecoder = JSONDecoder()

	private lazy var packageFileWrapper = FileWrapper(directoryWithFileWrappers: [:])

	public override func contents(forType typeName: String) throws -> Any {
		if packageFileWrapper.fileWrappers?[FileName.contents] == nil,
			let contentsData = contents.data(using: .utf8) {
			let contentsFileWrapper = FileWrapper(regularFileWithContents: contentsData)
			contentsFileWrapper.preferredFilename = FileName.contents
			packageFileWrapper.addFileWrapper(contentsFileWrapper)
		}

		if let settingsData = try? jsonEncoder.encode(settings) {
			let settingsFileWrapper = FileWrapper(regularFileWithContents: settingsData)
			settingsFileWrapper.preferredFilename = FileName.settings
			packageFileWrapper.addFileWrapper(settingsFileWrapper)
		}

		return packageFileWrapper
	}

	public override func load(fromContents contents: Any, ofType typeName: String?) throws {
		guard let packageFileWrapper = contents as? FileWrapper else {
			throw Playground.Error.noPackageFile
		}

		if let contentsFileWrapper = packageFileWrapper.fileWrappers?[FileName.contents],
			let contentsData = contentsFileWrapper.regularFileContents,
			let contentsString = String(data: contentsData, encoding: .utf8) {
			self.contents = contentsString
		}

		if let settingsFileWrapper = packageFileWrapper.fileWrappers?[FileName.settings],
			let settingsData = settingsFileWrapper.regularFileContents,
			let settings = try? jsonDecoder.decode(Settings.self, from: settingsData) {
			self.settings = settings
		}
	}
}

extension Playground {
	/// Used to represent errors when reading or storing a `Playground`.
	///
	/// - Note: Due to the public API of `UIDocument` you cannot actually
	/// inspect the thrown error. Instead `open` and `save` will only indicate
	/// failure by setting the `success` argument in their respective closures
	/// to `false`.
	enum Error: Swift.Error {
		case noPackageFile
		case noSettingsFile
	}
}

extension Playground {
	enum FileName {
		static let contents = "contents.graphql"
		static let settings = "settings.json"
	}
}

extension Playground {
	/// The `Playground`s settings.
	public struct Settings: Codable {
		/// The GraphQL APIs root endpoint to which the `Playground` sends queries.
		public let endpoint: URL?
	}
}

extension Playground.Settings: Equatable {}
