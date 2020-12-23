//
//  Operators.swift
//  Parsec
//
//  Created by Tangent on 2020/12/14.
//

precedencegroup AlternativePrecedence {
  associativity: left
}

precedencegroup FunctorPrecedence {
  associativity: left
  higherThan: AlternativePrecedence
}

infix operator <|> : AlternativePrecedence
infix operator *> : FunctorPrecedence
infix operator <* : FunctorPrecedence
