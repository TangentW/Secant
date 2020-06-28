//
//  Binding.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
public struct Binding<Value> {
    
    @inlinable
    public static func constant(_ value: Value) -> Binding {
        .init(get: { value }, set: { _ in })
    }

    @inlinable
    public init<ID>(id: ID, get: @escaping () -> Value, set: @escaping (Value) -> Void) where ID: Hashable {
        _get = get
        _set = set
        _id = AnyHashable(id)
    }
    
    @inlinable
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.init(id: UUID(), get: get, set: set)
    }
    
    @inlinable
    public var wrappedValue: Value {
        get { value }
        nonmutating set { value = newValue }
    }
    
    @inlinable
    public var value: Value {
        get { _get() }
        nonmutating set { _set(newValue) }
    }
    
    @inlinable
    public var projectedValue: Binding<Value> { self }
    
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> {
        .init(
            id: CompositeHashable(_id, keyPath),
            get: { self.wrappedValue[keyPath: keyPath] },
            set: { self.wrappedValue[keyPath: keyPath] = $0 }
        )
    }

    @usableFromInline
    let _get: () -> Value
    
    @usableFromInline
    let _set: (Value) -> Void
    
    @usableFromInline
    let _id: AnyHashable
}

extension Binding: Hashable {
    
    @inlinable
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        lhs._id == rhs._id
    }
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}
