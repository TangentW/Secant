//
//  CompositeHashable.swift
//  Secant
//
//  Created by Tangent on 2020/6/29.
//

internal struct CompositeHashable: Hashable {
    
    @inlinable
    init<A: Hashable, B: Hashable>(_ a: A, _ b: B) {
        _content = a._buildCompositeHashableContent() + b._buildCompositeHashableContent()
    }

    fileprivate let _content: [AnyHashable]
}

private extension Hashable {
    
    func _buildCompositeHashableContent() -> [AnyHashable] {
        if let compositeHashable = self as? CompositeHashable {
            return compositeHashable._content
        }
        return [self]
    }
}
