//
//  SimpleRow.swift
//  Secany
//
//  Created by Tangent on 2020/6/26.
//

import UIKit
import DifferenceKit

public struct SimpleRow<Data, Cell> where Data: Differentiable, Cell: UITableViewCell {
    
    public init(_ data: Data, cellType _: Cell.Type = Cell.self, render: @escaping (Data, Cell) -> Void) {
        _data = data
        _render = render
    }
    
    private let _data: Data
    private let _render: (Data, Cell) -> Void
}

extension SimpleRow: Row {
    
    public typealias Cell = Cell

    public func render(context: Context) {
        _render(_data, context.cell)
    }
    
    public var id: Data.DifferenceIdentifier {
        _data.differenceIdentifier
    }
    
    public func shouldRerender(old: SimpleRow<Data, Cell>) -> Bool {
        _data.isContentEqual(to: old._data)
    }
}
