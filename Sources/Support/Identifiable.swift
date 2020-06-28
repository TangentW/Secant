//
//  Identifiable.swift
//  Secant
//
//  Created by Tangent on 2020/6/29.
//

public protocol Identifiable {
    
    associatedtype ID: Hashable
    
    var id: ID { get }
}
