import Foundation

extension URLSessionDataTask: NetworkSessionDataTask {}

extension URLSession: NetworkSession {
	public func dataTask(
		with request: URLRequest,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> NetworkSessionDataTask {
		let dataTask: URLSessionDataTask = self.dataTask(with: request, completionHandler: completionHandler)
		return dataTask
	}
}
