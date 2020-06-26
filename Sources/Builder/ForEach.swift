//
//  ForEach.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

public struct ForEach<Element> {
    
    public let elements: [Element]
}

extension ForEach: Rows where Element == AnyRow {
    
    @inlinable
    public init<S>(_ sequence: S, @RowsBuilder transform: (S.Element) -> Rows) where S: Sequence {
        elements = sequence.map(transform).flatMap { $0._rows }
    }
    
    @inlinable
    public var _rows: [AnyRow] { elements }
}

extension ForEach: Sections where Element == Section {
    
    @inlinable
    public init<S>(_ sequence: S, @SectionsBuilder transform: (S.Element) -> Sections) where S: Sequence {
        elements = sequence.map(transform).flatMap { $0._sections }
    }
    
    @inlinable
    public var _sections: [Section] { elements }
}
