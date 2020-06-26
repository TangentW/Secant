//
//  Binding.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

@propertyWrapper
@dynamicMemberLookup
public struct Binding<Value> {
    
    @inlinable
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        _get = get
        _set = set
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
    
    @inlinable
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> {
        .init(
            get: { self.wrappedValue[keyPath: keyPath] },
            set: { self.wrappedValue[keyPath: keyPath] = $0 }
        )
    }

    @usableFromInline
    let _get: () -> Value
    
    @usableFromInline
    let _set: (Value) -> Void
}

extension Binding: Equatable where Value: Equatable {
    
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        lhs.value == rhs.value
    }
}
