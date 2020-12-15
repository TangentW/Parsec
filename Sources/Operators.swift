//
//  Operators.swift
//  Parsec
//
//  Created by Tangent on 2020/12/14.
//

precedencegroup MonadPrecedence {
  associativity: left
}

precedencegroup AlternativePrecedence {
  associativity: left
  higherThan: MonadPrecedence
}

precedencegroup FunctorPrecedence {
  associativity: left
  higherThan: AlternativePrecedence
}

infix operator >>- : MonadPrecedence
infix operator <|> : AlternativePrecedence
infix operator <^> : FunctorPrecedence
infix operator *> : FunctorPrecedence
infix operator <* : FunctorPrecedence
