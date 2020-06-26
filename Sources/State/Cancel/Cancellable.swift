//
//  Cancellable.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

// MARK: - Cancels

public enum Cancels { }

// MARK: - Cancellable

public protocol Cancellable {
    
    func cancel()
}
