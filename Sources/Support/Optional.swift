//
//  Optional.swift
//  Secant
//
//  Created by Tangent on 2020/6/28.
//

internal extension Optional {
    
    mutating func take() -> Wrapped? {
        guard let value = self else { return nil }
        self = nil
        return value
    }
}
