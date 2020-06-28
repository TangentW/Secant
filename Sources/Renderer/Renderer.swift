//
//  Renderer.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import UIKit
import DifferenceKit

public protocol Renderer where Self: NSObject {
    
    var view: UITableView? { get }
    var animation: UITableView.UpdateAnimation { get }
}

public extension Renderer {
    
    var animation: UITableView.UpdateAnimation { .init() }
}

// MARK: - Render Function

public extension Renderer {
    
    @inlinable
    func render(@RowsBuilder rows: () -> Rows) {
        render(rows()._rows)
    }
    
    @inlinable
    func render(@SectionsBuilder sections: () -> Sections) {
        render(sections()._sections)
    }
    
    @inlinable
    func render<Rows>(_ rows: Rows) where Rows: Collection, Rows.Element == AnyRow {
        render([Section(id: "", rows: rows)])
    }
    
    func render<Sections>(_ sections: Sections) where Sections: Collection, Sections.Element == Section {
        _scheduler.schedule(immediately: !_isDisplayed) { [weak self] in
            guard let self = self else { return }
            let changeset = StagedChangeset(source: self.data, target: Array(sections))
            self._update(batch: changeset)
        }
    }
}

private extension Renderer {
    
    var _isDisplayed: Bool {
        view?.window != nil
    }
    
    func _update(batch: StagedChangeset<[Section]>) {
        view?.reload(
            using: batch,
            deleteSectionsAnimation: animation.deleteSections,
            insertSectionsAnimation: animation.insertSections,
            reloadSectionsAnimation: animation.reloadSections,
            deleteRowsAnimation: animation.deleteRows,
            insertRowsAnimation: animation.insertRows,
            reloadRowsAnimation: animation.reloadRows,
            interrupt: { $0.changeCount > 30 },
            setData: _set(data:)
        )
    }
    
    var _scheduler: Scheduler {
        self[associated: _schedulerKey] ?? with(.init(interval: _schedulerInterval)) {
            self[associated: _schedulerKey] = $0
        }
    }
}

private let _schedulerKey = AssociatedKey<Scheduler>()
private let _schedulerInterval: TimeInterval = 1 / 60

// MARK: - For implementation

public extension Renderer {
    
    @inlinable
    subscript(row indexPath: IndexPath) -> AnyRow {
        self[rows: indexPath.section][indexPath.item]
    }

    @inlinable
    subscript(rows section: Int) -> [AnyRow] {
        self[section: section].rows
    }
    
    subscript(rowContext indexPath: IndexPath) -> AnyRow.Context? {
        guard
            let view = view,
            let cell = view.cellForRow(at: indexPath),
            let coordinator = cell.coordinator
        else { return nil }
        return .init(coordinator: coordinator, cell: cell, tableView: view, indexPath: indexPath)
    }

    subscript(headerFooter headerFooterType: HeaderFooterType) -> AnyHeaderFooter? {
        switch headerFooterType {
        case .header(let section):
            return self[section: section].header
        case .footer(let section):
            return self[section: section].footer
        }
    }
    
    @inlinable
    subscript(section section: Int) -> Section {
        data[section]
    }

    func obtainCellThenRender(at indexPath: IndexPath) -> UITableViewCell {
        guard let view = view else { return .init() }
        let row = self[row: indexPath]
        let cell = view.obtainCell(type: row.cellType, reuseId: row.reuseId)

        // Render
        let coordinator = cell.coordinator ?? with(row.install(cell: cell)) {
            cell.coordinator = $0
        }
        let context = AnyRow.Context(coordinator: coordinator, cell: cell, tableView: view, indexPath: indexPath)
        row.render(context: context)
        
        return cell
    }
    
    func obtainHeaderFooterThenRender(type: HeaderFooterType) -> UITableViewHeaderFooterView? {
        guard let headerFooter = self[headerFooter: type], let view = view else { return nil }
        let headerFooterView = view.obtainHeaderFooterView(type: headerFooter.viewType, reuseId: headerFooter.reuseId)

        // Render
        let coordinator = headerFooterView.coordinator ?? with(headerFooter.install(view: headerFooterView)) {
            headerFooterView.coordinator = $0
        }
        let context = AnyHeaderFooter.Context(coordinator: coordinator, view: headerFooterView, tableView: view, type: type)
        headerFooter.render(context: context)
        
        return headerFooterView
    }
}

// MARK: - Data

extension Renderer {
    
    public var data: [Section] {
        self[associated: _dataKey] ?? []
    }

    private func _set(data: [Section]) {
        self[associated: _dataKey] = data
    }
}

// MARK: - ReusableView

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }

private protocol ReusableView where Self: UIView { }

private extension ReusableView {
    
    var coordinator: Any? {
        get { self[associated: _coordinatorKey] }
        set { self[associated: _coordinatorKey] = newValue }
    }
}

// MARK: - Keys

private let _coordinatorKey = AssociatedKey<Any>()
private let _dataKey = AssociatedKey<[Section]>()

// MARK: -  For TableView

private extension UITableView {
    
    func obtainCell(type: UITableViewCell.Type, reuseId: String) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: reuseId)
            ?? with {
                register(type, forCellReuseIdentifier: reuseId)
                return dequeueReusableCell(withIdentifier: reuseId)
            }
            ?? .init()
    }
    
    func obtainHeaderFooterView(type: UITableViewHeaderFooterView.Type, reuseId: String) -> UITableViewHeaderFooterView {
        dequeueReusableHeaderFooterView(withIdentifier: reuseId)
            ?? with {
                register(type, forHeaderFooterViewReuseIdentifier: reuseId)
                return dequeueReusableHeaderFooterView(withIdentifier: reuseId)
            }
            ?? .init()
    }
}
