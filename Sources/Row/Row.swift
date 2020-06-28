//
//  Row.swift
//  Secant
//
//  Created by Tangent on 2020/6/19.
//

import UIKit
import DifferenceKit

public protocol Row: Differentiable, Rows {
    
    associatedtype ID: Hashable = UUID
    associatedtype Cell: UITableViewCell = UITableViewCell
    associatedtype Coordinator = Void

    typealias Context = RowContext<Self>
    
    var id: ID { get }

    func install(cell: Cell) -> Coordinator
    func render(context: Context)
    func shouldRerender(old: Self) -> Bool

    // Size of Row
    var height: CGFloat? { get }
    
    // Callbacks
    func didSelect(context: Context)
}

public extension Row {
    
    @inlinable
    var cellType: UITableViewCell.Type {
        Cell.self
    }
    
    @inlinable
    var reuseId: String {
        String(describing: Self.self)
    }
}

// MARK: - Default

public extension Row where ID == UUID {
    
    @inlinable
    var id: ID { UUID() }
}

public extension Row where Coordinator == Void {
    
    @inlinable
    func install(cell: Cell) { }
}

public extension Row where Self: Equatable {
    
    @inlinable
    func shouldRerender(old: Self) -> Bool {
        old != self
    }
}

public extension Row {
    
    @inlinable
    var height: CGFloat? { nil }
    
    @inlinable
    func didSelect(context: Context) { }
}

// MARK: - Protocol

public extension Row {
    
    // Rows:
    
    @inlinable
    var _rows: [AnyRow] { [eraseToAnyRow()] }
    
    // Differentiable:

    @inlinable
    var differenceIdentifier: ID { id }
    
    @inlinable
    func isContentEqual(to source: Self) -> Bool {
        !shouldRerender(old: source)
    }
}
