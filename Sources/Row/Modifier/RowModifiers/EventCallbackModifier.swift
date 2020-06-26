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
    
    @inlinable
    func onWillDisplay(_ callback: @escaping (Context) -> Void) -> EventCallbackModifier<Self> {
        .init(content: self, onWillDisplay: callback)
    }
    
    @inlinable
    func onDidEndDisplaying(_ callback: @escaping (Context) -> Void) -> EventCallbackModifier<Self> {
        .init(content: self, onDidEndDisplaying: didSelect)
    }
}

public struct EventCallbackModifier<Content>: RowModifier where Content: Row {
    
    public typealias Callback = (Content.Context) -> Void
    
    @inlinable
    public init(
        content: Content,
        onDidSelect: Callback? = nil,
        onWillDisplay: Callback? = nil,
        onDidEndDisplaying: Callback? = nil
    ) {
        self.content = content
        
        self.onDidSelect = onDidSelect
        self.onWillDisplay = onWillDisplay
        self.onDidEndDisplaying = onDidEndDisplaying
    }
    
    public let content: Content
    
    @usableFromInline
    let onDidSelect: Callback?
    @usableFromInline
    let onWillDisplay: Callback?
    @usableFromInline
    let onDidEndDisplaying: Callback?

    @inlinable
    public func didSelect(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        onDidSelect?(context)
    }
    
    @inlinable
    public func willDisplay(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        onWillDisplay?(context)
    }
    
    @inlinable
    public func didEndDisplaying(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        onDidEndDisplaying?(context)
    }
}
