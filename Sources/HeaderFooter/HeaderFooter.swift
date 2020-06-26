//
//  HeaderFooter.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

import UIKit
import DifferenceKit

public protocol HeaderFooter: ContentEquatable {
    
    associatedtype View: UITableViewHeaderFooterView = UITableViewHeaderFooterView
    associatedtype Coordinator = Void
    
    typealias Context = HeaderFooterContext<Self>
    
    func install(view: View) -> Coordinator
    func render(context: Context)
    func shouldRerender(old: Self) -> Bool
    
    // Size of HeaderFooter
    var height: CGFloat? { get }
    
    // Callbacks
    func willDisplay(context: Context)
    func didEndDisplaying(context: Context)
}

public extension HeaderFooter {
    
    @inlinable
    var viewType: UITableViewHeaderFooterView.Type {
        View.self
    }
    
    @inlinable
    var reuseId: String {
        String(describing: Self.self)
    }
}

// MARK: - Default

public extension HeaderFooter where Coordinator == Void {
    
    @inlinable
    func install(view: View) { }
}

public extension HeaderFooter where Self: Equatable {
    
    @inlinable
    func shouldRerender(old: Self) -> Bool {
        old != self
    }
}

public extension HeaderFooter {
    
    @inlinable
    func willDisplay(context: Context) { }
    
    @inlinable
    func didEndDisplaying(context: Context) { }
}

// MARK: - Protocol

public extension HeaderFooter {
    
    func isContentEqual(to source: Self) -> Bool {
        !shouldRerender(old: source)
    }
}
