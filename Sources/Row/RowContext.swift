//
//  RowContext.swift
//  Secant
//
//  Created by Tangent on 2020/6/19.
//

import UIKit

public struct RowContext<Content> where Content: Row {
    
    public let coordinator: Content.Coordinator
    public let cell: Content.Cell
    public let tableView: UITableView
    public let indexPath: IndexPath

    @inlinable
    internal init(coordinator: Content.Coordinator, cell: Content.Cell, tableView: UITableView, indexPath: IndexPath) {
        self.coordinator = coordinator
        self.cell = cell
        self.tableView = tableView
        self.indexPath = indexPath
    }
}

public extension RowContext {
    
    func map<R>(rowType: R.Type) -> RowContext<R>? {
        guard let coordinator = coordinator as? R.Coordinator, let cell = cell as? R.Cell else { return nil }
        return .init(coordinator: coordinator, cell: cell, tableView: tableView, indexPath: indexPath)
    }
}
