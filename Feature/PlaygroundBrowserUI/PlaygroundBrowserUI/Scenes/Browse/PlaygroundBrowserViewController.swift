import UIKit
import CommonUI

protocol PlaygroundBrowserViewControllerCoordinatorDelegate: class {
	func playgroundBrowserViewController(
		_ viewController: PlaygroundBrowserViewController,
		didRequestPlaygroundCreationWithImportHandler importHandler: @escaping (
		URL?, UIDocumentBrowserViewController.ImportMode
		) -> Void
	)
}

final class PlaygroundBrowserViewController: UIDocumentBrowserViewController {
	weak var coordinatorDelegate: PlaygroundBrowserViewControllerCoordinatorDelegate?

	init() {
		super.init(forOpeningFilesWithContentTypes: ["com.ocelotgraphql.playground"])
		delegate = self
		view.tintColor = .theme
	}

	required init?(coder aDecoder: NSCoder) {
		return nil
	}
}

extension PlaygroundBrowserViewController: UIDocumentBrowserViewControllerDelegate {
	func documentBrowser(
		_ controller: UIDocumentBrowserViewController,
		didPickDocumentsAt documentURLs: [URL]
	) {
		notifyUserAboutMissingEditingFeature()
	}

	func documentBrowser(
		_ controller: UIDocumentBrowserViewController,
		didPickDocumentURLs documentURLs: [URL]
	) {
		notifyUserAboutMissingEditingFeature()
	}

	func documentBrowser(
		_ controller: UIDocumentBrowserViewController,
		didRequestDocumentCreationWithHandler importHandler: @escaping (
			URL?, UIDocumentBrowserViewController.ImportMode
		) -> Void
	) {
		coordinatorDelegate?.playgroundBrowserViewController(self, didRequestPlaygroundCreationWithImportHandler: importHandler)
	}

	private func notifyUserAboutMissingEditingFeature() {
		let alertController = UIAlertController(
			title: "404 - Implementation not found",
			message: "Editing playgrounds is not yet implemented 🙈",
			preferredStyle: .alert
		)
		alertController.addAction(UIAlertAction(title: "Okay", style: .default))
		present(alertController, animated: true)
	}
}
