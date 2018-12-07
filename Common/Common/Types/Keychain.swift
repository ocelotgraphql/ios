import Foundation

public struct Keychain: SecureStringStore {
	private let syncsWithICloud: Bool
	private let searchQuery: CFDictionary

	public init(syncingWithICloud: Bool = true) {
		self.syncsWithICloud = syncingWithICloud
		let searchQuery: [String: Any] = [
			kSecClassKey as String: kSecClassGenericPassword,
			kSecAttrSynchronizable as String: syncsWithICloud,
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
				kSecAttrSynchronizable as String: syncsWithICloud,
				kSecValueData as String: data
			]
			let status = SecItemAdd(query as CFDictionary, nil)
			print(status)
		} else {
			SecItemDelete(searchQuery)
		}
	}
}
