import XCTest
@testable import Parsec

final class ParsecTests: XCTestCase {
    
    func testExample() {
        
        let inputOne = "hello world!"
        let inputTwo = ""

        let inputOneResultOfElement = element.parse(inputOne)
        let inputTwoResultOfElement = element.parse(inputTwo)

        let inputOneResultOfEndOfStream = endOfStream.parse(inputOne)
        let inputTwoResultOfEndOfStream = endOfStream.parse(inputTwo)
        
        print("inputOneResultOfElement: \(inputOneResultOfElement)")
        print("inputTwoResultOfElement: \(inputTwoResultOfElement)")
        print("")
        print("inputOneResultOfEndOfStream: \(inputOneResultOfEndOfStream)")
        print("inputTwoResultOfEndOfStream: \(inputTwoResultOfEndOfStream)")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
