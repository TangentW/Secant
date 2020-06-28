//
//  AnyRow.swift
//  Secant
//
//  Created by Tangent on 2020/6/20.
//

import UIKit

public extension Row {
    
    func eraseToAnyRow() -> AnyRow {
        (self as? AnyRow) ?? AnyRow(self)
    }
}

public struct AnyRow {
    
    public typealias ID = AnyHashable
    public typealias Cell = UITableViewCell
    public typealias Coordinator = Any

    public init<N>(_ row: N) where N: Row {
        _row = row
        _id = { AnyHashable(row.id) }
        _cellType = { row.cellType }
        _reuseId = { row.reuseId }
        _install = { cell in
            guard let cell = cell as? N.Cell else {
                assertionFailure()
                return ()
            }
            return row.install(cell: cell)
        }
        _render = {
            guard let context = $0.map(rowType: N.self) else {
                assertionFailure()
                return
            }
            row.render(context: context)
        }
        _shouldRerender = {
            guard let old = $0._row as? N else { return true }
            return row.shouldRerender(old: old)
        }
        _height = { row.height }
        _didSelect = {
            guard let context = $0.map(rowType: N.self) else {
                assertionFailure()
                return
            }
            row.didSelect(context: context)
        }
    }

    private let _row: Any
    
    @usableFromInline
    let _id: () -> ID
    @usableFromInline
    let _cellType: () -> UITableViewCell.Type
    @usableFromInline
    let _reuseId: () -> String
    @usableFromInline
    let _install: (Cell) -> Coordinator
    @usableFromInline
    let _render: (Context) -> Void
    @usableFromInline
    let _shouldRerender: (Self) -> Bool
    @usableFromInline
    let _height: () -> CGFloat?
    @usableFromInline
    let _didSelect: (Context) -> Void
}

extension AnyRow: Row {

    @inlinable
    public var id: ID { _id() }
    @inlinable
    public var cellType: UITableViewCell.Type { _cellType() }
    @inlinable
    public var reuseId: String { _reuseId() }
    @inlinable
    public func install(cell: Cell) -> Any { _install(cell) }
    @inlinable
    public func render(context: Context) { _render(context) }
    @inlinable
    public func shouldRerender(old: AnyRow) -> Bool { _shouldRerender(old) }
    @inlinable
    public var height: CGFloat? { _height() }
    @inlinable
    public func didSelect(context: Context) { _didSelect(context) }
}
