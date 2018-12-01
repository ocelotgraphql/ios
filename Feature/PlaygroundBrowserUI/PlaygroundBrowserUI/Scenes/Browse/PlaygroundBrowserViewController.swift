import UIKit
import CommonUI

final class PlaygroundBrowserViewController: UIDocumentBrowserViewController {
	init() {
		super.init(forOpeningFilesWithContentTypes: ["com.ocelotgraphql.playground"])
		view.tintColor = .theme
	}

	required init?(coder aDecoder: NSCoder) {
		return nil
	}
}
