//
//  IdentifierModifier.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

public extension Row {
    
    @inlinable
    func identified<ID>(by id: ID) -> IdentifierModifier<Self, ID> where ID: Hashable {
        .init(content: self, id: id)
    }
}

public struct IdentifierModifier<Content, ID>: RowModifier where Content: Row, ID: Hashable {
    
    @inlinable
    public init(content: Content, id: ID) {
        self.content = content
        self.id = id
    }
    
    public let content: Content
    public let id: ID
}
