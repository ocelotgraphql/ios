import Foundation

/// `SecureStringStore` based on Keychain.
public struct Keychain: SecureStringStore {
	private let searchQuery: CFDictionary

	/// Create a new `Keychain` instance.
	public init() {
		let searchQuery: [String: Any] = [
			kSecClassKey as String: kSecClassGenericPassword,
			kSecAttrSynchronizable as String: true,
			kSecReturnData as String: true
		]
		self.searchQuery = searchQuery as CFDictionary
	}

	public subscript(key: String) -> String? {
		get {
			return value(for: key)
		} set (newValue) {
			set(newValue, for: key)
		}
	}

	private func value(for key: String) -> String? {
		var item: CFTypeRef?
		_ = SecItemCopyMatching(searchQuery, &item)
		if let data = item as? Data, let value = String(data: data, encoding: .utf8) {
			return value
		} else {
			return nil
		}
	}

	private func set(_ value: String?, for key: String) {
		if let value = value, let data = value.data(using: .utf8) {
			let query: [String: Any] = [
				kSecClassKey as String: kSecClassGenericPassword,
				kSecAttrSynchronizable as String: true,
				kSecValueData as String: data
			]
			let status = SecItemAdd(query as CFDictionary, nil)
			print(status)
		} else {
			SecItemDelete(searchQuery)
		}
	}
}
