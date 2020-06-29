//
//  Transaction.swift
//  Secant
//
//  Created by Tangent on 2020/6/29.
//

import Foundation

public struct Transaction {
    
    public init(config: (inout Transaction) -> Void) {
        var instance = Transaction()
        config(&instance)
        self = instance
    }
    
    public init() {
        _content = [:]
    }
    
    private var _content: [UUID: Any]
}

public extension Transaction {
    
    struct Key<Value>: Hashable {
        
        let id = UUID()
        
        @inlinable
        public init(valueType _: Value.Type = Value.self) { }
    }
    
    subscript<Value>(key: Key<Value>) -> Value? {
        get { _content[key.id] as? Value }
        set { _content[key.id] = newValue }
    }
}

public extension Transaction {
    
    @discardableResult
    func begin<T>(work: () throws -> T) rethrows -> T {
        assert(Thread.isMainThread)
        _TransactionStore.shared.push(self)
        defer { _TransactionStore.shared.pop() }
        return try work()
    }
    
    static var current: Transaction? {
        assert(Thread.isMainThread)
        return _TransactionStore.shared.peek()
    }
}

private final class _TransactionStore {
    
    static let shared = _TransactionStore()
    
    func push(_ transaction: Transaction) {
        _transactionStack.append(transaction)
    }
    
    @discardableResult
    func pop() -> Transaction? {
        guard !_transactionStack.isEmpty else { return nil }
        return _transactionStack.removeLast()
    }
    
    func peek() -> Transaction? {
        _transactionStack.last
    }
    
    private var _transactionStack: [Transaction] = []
    
    private init() { }
}
