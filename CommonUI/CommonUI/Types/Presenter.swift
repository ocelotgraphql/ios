/// Presents `Presentable`s in different ways.
public protocol Presenter {
	func setRootModule(_ module: Presentable?, hideNavigationBar: Bool)
}
