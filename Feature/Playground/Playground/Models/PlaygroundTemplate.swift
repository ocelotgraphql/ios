extension Playground {
	/// A `Playground.Template` provides the basis of which new
	/// `Playground`s are created.
	public struct Template {
		/// The `Playground`s settings.
		public let settings: Settings

		/// The `Playground`s contents.
		public let contents: String

		public static let `default` = Template()

		private init(settings: Settings = Settings(), contents: String = "\n") {
			self.settings = settings
			self.contents = contents
		}
	}
}
