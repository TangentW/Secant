//
//  HeightModifier.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

import UIKit

public extension Row {
    
    @inlinable
    func height(_ height: CGFloat) -> HeightModifier<Self> {
        .init(content: self, height: height)
    }
}

public struct HeightModifier<Content>: RowModifier where Content: Row {
    
    @inlinable
    public init(content: Content, height: CGFloat) {
        self.content = content
        self.height = height
    }
    
    public let content: Content
    public let height: CGFloat?
    
    public func shouldRerender(old: HeightModifier<Content>) -> Bool {
        let original = content.shouldRerender(old: old.content)
        return original || height != old.height
    }
}
