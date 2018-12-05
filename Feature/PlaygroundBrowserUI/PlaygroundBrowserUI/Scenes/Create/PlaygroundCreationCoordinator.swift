import UIKit
import CommonUI

typealias PlaygroundCreationImportHandler = (URL?, UIDocumentBrowserViewController.ImportMode) -> Void

final class PlaygroundCreationCoordinator: Coordinator {
	private let presenter: Presenter
	private let importHandler: PlaygroundCreationImportHandler

	init(presenter: Presenter, importHandler: @escaping PlaygroundCreationImportHandler) {
		self.presenter = presenter
		self.importHandler = importHandler
	}

	func start() {
		print("Choose template")
		importHandler(nil, .none)
	}
}
