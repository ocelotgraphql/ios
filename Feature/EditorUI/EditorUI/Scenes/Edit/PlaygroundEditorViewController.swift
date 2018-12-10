import Playground
import UIKit
import CommonUI

final class PlaygroundEditorViewController: UIViewController {
	private let playground: Playground

	private lazy var editorTextView: UITextView = {
		let textView = UITextView()
		textView.isEditable = false
		textView.textColor = .theme
		textView.tintColor = .theme
		textView.font = .preferredFont(forTextStyle: .body)
		textView.text = playground.contents
		return textView
	}()

	init(editing playground: Playground) {
		self.playground = playground
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		return nil
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		editorTextView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(editorTextView)
		activateConstraints()
	}

	private func activateConstraints() {
		NSLayoutConstraint.activate([
			editorTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
			editorTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			editorTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			editorTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
		])
	}
}
