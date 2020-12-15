//
//  Error.swift
//  Parsec
//
//  Created by Tangent on 2020/12/14.
//

public struct Error: Swift.Error {
    
    public let stream: Context.Stream
    public let position: Context.Index
    public let message: String

    public init(stream: Context.Stream, position: Context.Index, message: String) {
        self.stream = stream
        self.position = position
        self.message = message
    }
}

public extension Error {
    
    func merge(with another: Error) -> Error {
        position > another.position ? self : another
    }
}

extension Error: CustomStringConvertible {
    
    public var description: String {
        let (line, column) = lineAndColumn
        return "[\(line):\(column)]\(message)"
    }
    
    public var lineAndColumn: (line: Int, column: Int) {
        stream.reduce(into: (line: 1, column: 1)) {
            if $1.isNewline {
                $0 = ($0.line + 1, 1)
            } else if $1 == "\t" {
                $0.column = $0.column + 8 - ($0.column - 1) % 8
            } else {
                $0.column += 1
            }
        }
    }
}
