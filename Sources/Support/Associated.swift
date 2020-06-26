//
//  Associate.swift
//  Secant
//
//  Created by Tangent on 2020/6/19.
//

import Foundation

@usableFromInline
internal final class AssociatedKey<Value> {
    
    @usableFromInline
    let _key = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
    
    @inlinable
    init(_: Value.Type = Value.self) {
        _key.initialize(to: 0)
    }
    
    @inlinable
    deinit {
        _key.deinitialize(count: 1)
        _key.deallocate()
    }
}

internal extension NSObject {
    
    @inlinable
    subscript<Value>(associated key: AssociatedKey<Value>) -> Value? {
        get {
            // `Value` maybe `Optional`
            // objc_getAssociatedObject(self, key._key) as? Value
            guard let object = objc_getAssociatedObject(self, key._key) else { return nil }
            return object as? Value
        }
        set {
            objc_setAssociatedObject(self, key._key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
