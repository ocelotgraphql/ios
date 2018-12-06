import Foundation

/// Abstraction for URLSessionTask
public protocol NetworkSessionDataTask {
	func resume()
}

/// Possible errors thrown when working with `NetworkSession`s
public enum NetworkSessionError: Error {
	case unknown
	case network(Error)
	case nonHTTPResponse(URLResponse)
	case unsuccessfulResponse(HTTPURLResponse, Data)
}

/// Abstraction for URLSession
public protocol NetworkSession {
	func dataTask(
		with request: URLRequest,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> NetworkSessionDataTask
}
