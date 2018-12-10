import UIKit
import CommonUI

protocol PlaygroundAccessTokenViewControllerDelegate: class {
	func accessTokenViewController(
		_ accessTokenViewController: PlaygroundAccessTokenViewController,
		accessTokenDidChange accessToken: String
	)
}

final class PlaygroundAccessTokenViewController: UIViewController {
	weak var coordinatorDelegate: PlaygroundAccessTokenViewControllerDelegate?

	private lazy var textField: UITextField = {
		let textField = UITextField()
		textField.autocorrectionType = .no
		textField.autocapitalizationType = .none
		textField.isSecureTextEntry = true
		textField.tintColor = .theme
		textField.textColor = .theme
		textField.font = .preferredFont(forTextStyle: .body)
		textField.placeholder = "Personal Access Token"
		return textField
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		textField.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(textField)
		activateConstraints()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textDidChange),
			name: UITextField.textDidChangeNotification,
			object: nil
		)
		textField.becomeFirstResponder()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}

	private func activateConstraints() {
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
		])
	}

	@objc private func textDidChange() {
		guard let token = textField.text else { return }
		coordinatorDelegate?.accessTokenViewController(self, accessTokenDidChange: token)
	}
}
