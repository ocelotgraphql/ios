import UIKit
import CommonUI

final class PlaygroundBrowserViewController: UIDocumentBrowserViewController {
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
		notifyUserAboutMissingCreationFeature()
		importHandler(nil, .none)
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

	private func notifyUserAboutMissingCreationFeature() {
		let alertController = UIAlertController(
			title: "404 - Implementation not found",
			message: "Creating new playgrounds is not yet implemented 🙈", preferredStyle: .alert
		)
		alertController.addAction(UIAlertAction(title: "Okay", style: .default))
		present(alertController, animated: true)
	}
}
