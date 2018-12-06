import XCTest
@testable import Common

class URLSessionNetworkSessionTests: XCTestCase {
    var sessionUnderTest: URLSession!
    
    let testURL = URL(string: "https://test.com")!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testTheDataTaskMethodReturnsAURLSessionDataTask() {
        let request = URLRequest(url: testURL)
        let networkSession: NetworkSession = URLSession.shared
        let dataTask = networkSession.dataTask(with: request) { _, _, _ in }
        
        XCTAssertTrue(dataTask is  URLSessionDataTask)
    }
}
