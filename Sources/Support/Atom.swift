//
//  Atom.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import Foundation

@propertyWrapper
internal final class Atom<Value> {

    var value: Value {
        get {
            _lock.lock(); defer { _lock.unlock() }
            return _value
        }
        set {
            _lock.lock(); defer { _lock.unlock() }
            _value = newValue
        }
    }
    
    @inlinable
    var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }
    
    @inlinable
    var projectedValue: Atom<Value> { self }

    @inlinable
    init(_ value: Value) {
        _value = value
    }
    
    @inlinable
    convenience init(wrappedValue: Value)  {
        self.init(wrappedValue)
    }
    
    @discardableResult
    func with<T>(_ work: (inout Value) throws -> T) rethrows -> T {
        _lock.lock(); defer { _lock.unlock() }
        return try work(&_value)
    }

    private var _value: Value
    private let _lock = Lock()
}

extension Atom where Value: Equatable {
    
    func compareAndSwap(expect: Value, new: Value) -> Bool {
        with {
            guard $0 == expect else { return false }
            $0 = new
            return true
        }
    }
}

internal final class Lock {
    
    private var _inner = pthread_mutex_t()
    
    @inlinable
    init() {
        let success = pthread_mutex_init(&_inner, nil) == 0
        assert(success)
    }
    
    @inlinable
    deinit {
        let success = pthread_mutex_destroy(&_inner) == 0
        assert(success)
    }
    
    @inlinable
    func lock() {
        let success = pthread_mutex_lock(&_inner) == 0
        assert(success)
    }
    
    @inlinable
    func unlock() {
        let success = pthread_mutex_unlock(&_inner) == 0
        assert(success)
    }
    
    @discardableResult
    func with<T>(_ work: () throws -> T) rethrows -> T {
        lock(); defer { unlock() }
        return try work()
    }
}
