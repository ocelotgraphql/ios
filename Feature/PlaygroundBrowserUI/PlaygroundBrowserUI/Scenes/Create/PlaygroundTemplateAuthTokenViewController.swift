import UIKit

final class PlaygroundTemplateAuthTokenViewController: UIViewController {
	var authTokenDidChange: ((String) -> Void)?

	private lazy var textField: UITextField = {
		let textField = UITextField()
		textField.font = .preferredFont(forTextStyle: .body)
		textField.placeholder = "Personal access token"
		textField.textColor = .theme
		textField.tintColor = .theme
		textField.isSecureTextEntry = true
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		return textField
	}()

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		textField.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(textField)

		activateConstraints()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textFieldDidChange),
			name: UITextField.textDidChangeNotification,
			object: nil
		)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		textField.becomeFirstResponder()
	}

	private func activateConstraints() {
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
		])
	}

	@objc private func textFieldDidChange() {
		authTokenDidChange?(textField.text ?? "")
	}
}
