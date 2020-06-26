//
//  CellModifier.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

import UIKit

public extension Row {
    
    func onInstall(_ callback: @escaping (Cell, Coordinator) -> Void) -> CellModifier<Self> {
        .init(content: self, onInstall: callback)
    }
    
    func onRender(_ callback: @escaping (Context) -> Void) -> CellModifier<Self> {
        .init(content: self, onRender: callback)
    }
}

public struct CellModifier<Content>: RowModifier where Content: Row {
    
    public init(
        content: Content,
        onInstall: ((Cell, Coordinator) -> Void)? = nil,
        onRender: ((Content.Context) -> Void)? = nil
    ) {
        self.content = content
        self.onInstall = onInstall
        self.onRender = onRender
    }
    
    public let content: Content
    
    @usableFromInline
    let onInstall: ((Cell, Coordinator) -> Void)?
    @usableFromInline
    let onRender: ((Content.Context) -> Void)?
    
    @inlinable
    public func install(cell: Content.Cell) -> Content.Coordinator {
        with(content.install(cell: cell)) {
            onInstall?(cell, $0)
        }
    }
    
    @inlinable
    public func render(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        content.render(context: context)
        onRender?(context)
    }
}
