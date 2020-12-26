import XCTest
@testable import Parsec

final class ParsecTests: XCTestCase {
    
    func testExample() {
        let arrow = string("=>").between(space.many, space.many)

        typealias Entry = (key: String, value: String)

        let entry: Parser<Entry> = stringLiteral.flatMap { key in
            (arrow *> stringLiteral).map { value in
                (key, value)
            }
        }

        let entries = (entry <* (newline <|> endOfStream)).some

        
        let string = """
        "name" => "Tangent"
        "city" => "深圳"
        "introduction" => "iOS开发者"
        """
        let result = entries.parse(string)
        
        print(result)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
