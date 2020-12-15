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

public let whitespace = element.filter("expecting whitespace") { $0.isWhitespace }

public let newline = element.filter("expecting newline") { $0.isNewline }
