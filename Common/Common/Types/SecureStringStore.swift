/// Implementing types provide a secure storage for strings.
public protocol SecureStringStore: class {
	subscript(key: String) -> String? { get set }
}
