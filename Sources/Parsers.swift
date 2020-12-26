//
//  Parsers.swift
//  Parsec
//
//  Created by Tangent on 2020/12/14.
//

public let element = Parser<Context.Element> {
    if let element = $0.next() {
        return .success(element)
    } else {
        return $0.throw("unexpected end of stream")
    }
}

public let endOfStream = Parser<()> {
    if $0.next() == nil {
        return .success(())
    } else {
        return $0.throw("expecting end of stream")
    }
}

public func char(_ char: Character) -> Parser<Character> {
    element.equal(to: char)
}

public func notChar(_ char: Character) -> Parser<Character> {
    element.notEqual(to: char)
}

public func string(_ string: String) -> Parser<String> {
    .init {
        for element in string {
            if case .failure(let error) = char(element).parse($0) {
                return .failure(error)
            }
        }
        return .success(string)
    }
}

public let charLiteral = element.between(char("'"), char("'"))

public let stringLiteral = notChar("\"").many
    .map { String($0) }
    .between(char("\""), char("\""))

public let space = element.filter("expecting whitespace") { $0 == " " }
    .map { _ in }

public let newline = element.filter("expecting newline") { $0.isNewline }
    .map { _ in }
