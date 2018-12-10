import UIKit
import Playground
import CommonUI

protocol PlaygroundBrowserViewControllerDelegate: class {
	func playgroundBrowserDidRequestPlaygroundCreation(_ playgroundBrowser: PlaygroundBrowserViewController)
	func playgroundBrowser(_ playgroundBrowser: PlaygroundBrowserViewController, didOpen playground: Playground)
}

final class PlaygroundBrowserViewController: UIDocumentBrowserViewController {
	weak var coordinatorDelegate: PlaygroundBrowserViewControllerDelegate?
	private var importHandler: ((URL?, UIDocumentBrowserViewController.ImportMode) -> Void)?

	init() {
		super.init(forOpeningFilesWithContentTypes: ["com.ocelotgraphql.playground"])
		delegate = self
		view.tintColor = .theme
	}

	required init?(coder aDecoder: NSCoder) {
		return nil
	}

	func cancelPlaygroundCreation() {
		importHandler?(nil, .none)
		importHandler = nil
	}

	func createPlayground(from template: Playground.Template) {
		let playground = Playground.Builder(from: template).build()
		playground.save(to: playground.fileURL, for: .forCreating) { [weak self] success in
			if success {
				self?.importHandler?(playground.fileURL, .move)
			} else {
				self?.cancelPlaygroundCreation()
			}
		}
	}

	private func openPlayground(at url: URL) {
		let playground = Playground(fileURL: url)
		playground.open { [weak self] success in
			guard let self = self, success else { return }
			self.coordinatorDelegate?.playgroundBrowser(self, didOpen: playground)
		}
	}
}

extension PlaygroundBrowserViewController: UIDocumentBrowserViewControllerDelegate {
	func documentBrowser(
		_ controller: UIDocumentBrowserViewController,
		didPickDocumentsAt documentURLs: [URL]
	) {
		guard let playgroundURL = documentURLs.first else { return }
		openPlayground(at: playgroundURL)
	}

	func documentBrowser(
		_ controller: UIDocumentBrowserViewController,
		didPickDocumentURLs documentURLs: [URL]
	) {
		guard let playgroundURL = documentURLs.first else { return }
		openPlayground(at: playgroundURL)
	}

	func documentBrowser(
		_ controller: UIDocumentBrowserViewController,
		didRequestDocumentCreationWithHandler importHandler: @escaping (
			URL?, UIDocumentBrowserViewController.ImportMode
		) -> Void
	) {
		self.importHandler = importHandler
		coordinatorDelegate?.playgroundBrowserDidRequestPlaygroundCreation(self)
	}

	func documentBrowser(
		_ controller: UIDocumentBrowserViewController,
		didImportDocumentAt sourceURL: URL,
		toDestinationURL destinationURL: URL
	) {
		openPlayground(at: destinationURL)
	}
}
