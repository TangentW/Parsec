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
        return "[\(line):\(column)] \(message)"
    }
    
    public var lineAndColumn: (line: Int, column: Int) {
        var (line, column) = (1, 1)
        var index = stream.startIndex

        while index != stream.endIndex, index != position {
            defer { stream.formIndex(after: &index) }
            let char = stream[index]
            
            if char.isNewline {
                (line, column) = (line + 1, 1)
            } else if char == "\t" {
                column = column + 8 - (column - 1) % 8
            } else {
                column += 1
            }
        }
        return (line, column)
    }
}
