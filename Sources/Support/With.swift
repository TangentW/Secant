//
//  With.swift
//  Secant
//
//  Created by Tangent on 2020/6/19.
//

@inlinable
@discardableResult
internal func with<T>(_ work: () throws -> T) rethrows -> T {
    try work()
}
 
@inlinable
@discardableResult
internal func with<T>(_ value: T, work: (inout T) throws -> Void) rethrows -> T {
    var value = value
    try work(&value)
    return value
}

@inlinable
@discardableResult
internal func with<T, O>(_ original: T, mapper: (inout T) throws -> O) rethrows -> O {
    var original = original
    return try mapper(&original)
}
