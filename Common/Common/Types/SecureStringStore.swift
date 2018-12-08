/// Implementing types provide a secure storage for strings.
public protocol SecureStringStore {
	subscript(key: String) -> String? { get set }
}
