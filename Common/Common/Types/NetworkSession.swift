import Foundation

public protocol NetworkSessionDataTask {
	func resume()
}

public enum NetworkSessionError: Error {
	case unknown
	case network(Error)
	case nonHTTPResponse(URLResponse)
	case unsuccessfulResponse(HTTPURLResponse, Data)
}

public protocol NetworkSession {
	func dataTask(
		with request: URLRequest,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> NetworkSessionDataTask
}
