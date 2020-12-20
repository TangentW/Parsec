//
//  Combinators.swift
//  Parsec
//
//  Created by Tangent on 2020/12/14.
//

// MARK: - Monad

public extension Parser {
    
    static func just(_ value: Value) -> Parser<Value> {
        .init { _ in .success(value) }
    }
    
    static func error<T>(_ error: Error) -> Parser<T> {
        .init { _ in .failure(error) }
    }
    
    static func `throw`(_ errorMessage: String) -> Parser<Value> {
        .init { $0.throw(errorMessage) }
    }
    
    func flatMap<O>(_ transform: @escaping (Value) -> Parser<O>) -> Parser<O> {
        .init {
            switch self.parse($0) {
            case .success(let value):
                return transform(value).parse($0)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func flatMapError(_ transform: @escaping (Error) -> Parser<Value>) -> Parser<Value> {
        .init {
            switch self.parse($0) {
            case .success(let value):
                return .success(value)
            case .failure(let error):
                return transform(error).parse($0)
            }
        }
    }
}

public func >>- <L, R>(lhs: Parser<L>, rhs: @escaping (L) -> Parser<R>) -> Parser<R> {
    lhs.flatMap(rhs)
}

// MARK: - Functor

public extension Parser {
    
    func map<O>(_ transform: @escaping (Value) -> O) -> Parser<O> {
        flatMap {
            .just(transform($0))
        }
    }
    
    func mapError(_ transform: @escaping (Error) -> Error) -> Parser<Value> {
        flatMapError {
            .error(transform($0))
        }
    }
}

public func <^> <L, R>(lhs: @escaping (L) -> R, rhs: Parser<L>) -> Parser<R> {
    rhs.map(lhs)
}

// MARK: - Applicative

public extension Parser {
    
    func usePrevious<O>(_ next: Parser<O>) -> Parser<Value> {
        flatMap { previous in next.map { _ in previous } }
    }
    
    func useNext<O>(_ next: Parser<O>) -> Parser<O> {
        flatMap { _ in next }
    }
    
    func between<L, R>(_ left: Parser<L>, _ right: Parser<R>) -> Parser<Value> {
        left *> self <* right
    }
}

public func <* <L, R>(lhs: Parser<L>, rhs: Parser<R>) -> Parser<L> {
    lhs.usePrevious(rhs)
}

public func *> <L, R>(lhs: Parser<L>, rhs: Parser<R>) -> Parser<R> {
    lhs.useNext(rhs)
}

// MARK: - Alternative

public extension Parser {
    
    func or(_ another: Parser<Value>) -> Parser<Value> {
        flatMapError { error in
            another.mapError(error.merge)
        }
    }
}

public func <|> <T>(lhs: Parser<T>, rhs: Parser<T>) -> Parser<T> {
    lhs.or(rhs)
}

// MARK: - Many & Some

public extension Parser {
    
    var many: Parser<[Value]> {
        some <|> .just([])
    }
    
    var some: Parser<[Value]> {
        flatMap { first in
            .init {
                var result = [first]
                while case .success(let value) = self.parse($0) {
                    result.append(value)
                }
                return .success(result)
            }
        }
    }
}

// MARK: - Satisfy

public extension Parser {
    
    func equal(to value: Value) -> Parser<Value> where Value: Equatable {
        filter("expecting \(value)") { $0 == value }
    }

    func notEqual(to value: Value) -> Parser<Value> where Value: Equatable {
        filter("unexpected \(value)") { $0 != value }
    }
    
    func filter(_ label: String, predicate: @escaping (Value) -> Bool) -> Parser<Value> {
        flatMap {
            predicate($0) ? .just($0) : .throw(label)
        }
    }
}
