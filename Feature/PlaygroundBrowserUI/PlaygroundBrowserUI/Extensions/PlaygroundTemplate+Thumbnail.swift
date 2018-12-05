import UIKit
import Playground

extension Playground.Template {
	var thumbnail: UIImage? {
		switch self {
		case .empty:
			return nil
		case .gitHub:
			return UIImage(named: "GitHub", in: Bundle(for: PlaygroundBrowserCoordinator.self), compatibleWith: nil)
		}
	}
}
