//
//  EventCallbackModifier.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

import UIKit

public extension Row {
    
    @inlinable
    func onDidSelect(_ callback: @escaping (Context) -> Void) -> EventCallbackModifier<Self> {
        .init(content: self, onDidSelect: callback)
    }
}

public struct EventCallbackModifier<Content>: RowModifier where Content: Row {
    
    public typealias Callback = (Content.Context) -> Void
    
    @inlinable
    public init(
        content: Content,
        onDidSelect: Callback? = nil
    ) {
        self.content = content
        self.onDidSelect = onDidSelect
    }
    
    public let content: Content
    
    @usableFromInline
    let onDidSelect: Callback?

    @inlinable
    public func didSelect(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        onDidSelect?(context)
    }
}
