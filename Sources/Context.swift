//
//  Context.swift
//  Parsec
//
//  Created by Tangent on 2020/12/14.
//

public final class Context {
    
    public typealias Stream = String
    public typealias Element = Stream.Element
    public typealias Index = Stream.Index
    
    public let stream: Stream
    
    public init(stream: Stream) {
        self.stream = stream
        _cursor = stream.startIndex
    }
    
    private var _cursor: Index
}

// MARK: - Transaction

public extension Context {
    
    func `do`<T>(_ work: (Context) -> Result<T, Error>) -> Result<T, Error> {
        let rewind = { [_cursor] in self._cursor = _cursor }
        let result = work(self)
        if case .failure = result { rewind() }
        return result
    }
}

// MARK: - Iterator

extension Context: IteratorProtocol {
    
    public func next() -> Element? {
        let range = stream.startIndex..<stream.endIndex
        guard range.contains(_cursor) else {
            return nil
        }
        defer {
            stream.formIndex(after: &_cursor)
        }
        return stream[_cursor]
    }
}

// MARK: - Error

public extension Context {
    
    func `throw`<T>(_ errorMessage: String) -> Result<T, Error> {
        .failure(error(with: errorMessage))
    }
    
    func error(with message: Stream) -> Error {
        .init(stream: stream, position: _cursor, message: message)
    }
}
