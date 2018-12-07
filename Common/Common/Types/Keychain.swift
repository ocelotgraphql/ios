import Foundation

/// `SecureStringStore` based on Keychain.
public struct Keychain: SecureStringStore {
	/// Create a new `Keychain` instance.
	public init() {}

	public subscript(key: String) -> String? {
		get {
			return value(for: key)
		} set (newValue) {
			set(newValue, for: key)
		}
	}

	private func value(for key: String) -> String? {
		var item: CFTypeRef?
		_ = SecItemCopyMatching(searchQuery(for: key), &item)
		if let data = item as? Data, let value = String(data: data, encoding: .utf8) {
			return value
		} else {
			return nil
		}
	}

	private func set(_ value: String?, for key: String) {
		if let value = value, let data = value.data(using: .utf8) {
			let query: [String: Any] = [
				kSecClass as String: kSecClassGenericPassword,
				kSecAttrService as String: key,
				kSecAttrSynchronizable as String: true,
				kSecValueData as String: data
			]
			_ = SecItemAdd(query as CFDictionary, nil)
		} else {
			SecItemDelete(searchQuery(for: key))
		}
	}

	private func searchQuery(for key: String) -> CFDictionary {
		let searchQuery: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrService as String: key,
			kSecAttrSynchronizable as String: true,
			kSecReturnData as String: true
		]
		return searchQuery as CFDictionary
	}
}
