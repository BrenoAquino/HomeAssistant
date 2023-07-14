import XCTest
@testable import Data

final class DataTests: XCTestCase {
    func testExample() throws {

        let message = AuthMessage(accessToken: "test")
        guard let data = try? JSONEncoder().encode(message) else {
            XCTFail()
            return
        }
        let dict = try? JSONSerialization.jsonObject(with: data) as? [String : Any]

        XCTAssertEqual(Data().text, "Hello, World!")
    }
}
