//
//  Parser.swift
//  Parsec
//
//  Created by Tangent on 2020/12/14.
//

public struct Parser<Value> {

    public typealias Result = Swift.Result<Value, Error>

    public let parse: (Context) -> Result
    
    public init(_ parse: @escaping (Context) -> Result) {
        self.parse = { $0.do(parse) }
    }
}

public extension Parser {
    
    func callAsFunction(_ context: Context) -> Result {
        parse(context)
    }
}

public extension Parser {
    
    func parse(_ stream: Context.Stream) -> Result {
        self(.init(stream: stream))
    }
}
