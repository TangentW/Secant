//  AnyHeaderFooter
//  Secant.swift
//  
//
//  Created by Tangent on 2020/6/26.
//

import UIKit

public extension HeaderFooter {
    
    func eraseToAnyHeaderFooter() -> AnyHeaderFooter {
        (self as? AnyHeaderFooter) ?? AnyHeaderFooter(self)
    }
}

public struct AnyHeaderFooter {
    
    public typealias View = UITableViewHeaderFooterView
    public typealias Coordinator = Any

    public init<HF>(_ headerFooter: HF) where HF: HeaderFooter {
        _headerFooter = headerFooter
        _viewType = { headerFooter.viewType }
        _reuseId = { headerFooter.reuseId }
        _install = { view in
            guard let view = view as? HF.View else {
                assertionFailure()
                return ()
            }
            return headerFooter.install(view: view)
        }
        _render = {
            guard let context = $0.map(headerFooterType: HF.self) else {
                assertionFailure()
                return
            }
            headerFooter.render(context: context)
        }
        _shouldRerender = {
            guard let old = $0._headerFooter as? HF else { return true }
            return headerFooter.shouldRerender(old: old)
        }
        _height = { headerFooter.height }
    }
    
    private let _headerFooter: Any
    
    @usableFromInline
    let _viewType: () -> UITableViewHeaderFooterView.Type
    @usableFromInline
    let _reuseId: () -> String
    @usableFromInline
    let _install: (View) -> Coordinator
    @usableFromInline
    let _render: (Context) -> Void
    @usableFromInline
    let _shouldRerender: (Self) -> Bool
    @usableFromInline
    let _height: () -> CGFloat?
}

extension AnyHeaderFooter: HeaderFooter {
    
    @inlinable
    public var viewType: UITableViewHeaderFooterView.Type { _viewType() }
    @inlinable
    public var reuseId: String { _reuseId() }
    @inlinable
    public func install(view: View) -> Coordinator { _install(view) }
    @inlinable
    public func render(context: Context) { _render(context) }
    @inlinable
    public func shouldRerender(old: Self) -> Bool { _shouldRerender(old) }
    @inlinable
    public var height: CGFloat? { _height() }
}
