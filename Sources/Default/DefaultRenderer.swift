//
//  DefaultRenderer.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import UIKit
import DifferenceKit

public class DefaultRenderer: NSObject, Renderer {
    
    public private(set) weak var view: UITableView?

    public init(tableView: UITableView) {
        self.view = tableView
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - DataSource

extension DefaultRenderer: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self[rows: section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        obtainCellThenRender(at: indexPath)
    }
}

// MARK: - Delegate

extension DefaultRenderer: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self[row: indexPath].height ?? tableView.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let context = self[rowContext: indexPath] else { return }
        self[row: indexPath].didSelect(context: context)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let context = self[rowContext: indexPath] else { return }
        self[row: indexPath].willDisplay(context: context)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let context = self[rowContext: indexPath] else { return }
        self[row: indexPath].didEndDisplaying(context: context)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        obtainHeaderFooterThenRender(type: .header(section: section))
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        obtainHeaderFooterThenRender(type: .footer(section: section))
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = self[headerFooter: .header(section: section)] else { return 0 }
        return header.height ?? tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = self[headerFooter: .footer(section: section)] else { return 0 }
        return footer.height ?? tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let context = self[headerFooterContext: .header(section: section)] else { return }
        self[headerFooter: .header(section: section)]?.willDisplay(context: context)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let context = self[headerFooterContext: .footer(section: section)] else { return }
        self[headerFooter: .footer(section: section)]?.willDisplay(context: context)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard let context = self[headerFooterContext: .header(section: section)] else { return }
        self[headerFooter: .header(section: section)]?.didEndDisplaying(context: context)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        guard let context = self[headerFooterContext: .footer(section: section)] else { return }
        self[headerFooter: .footer(section: section)]?.didEndDisplaying(context: context)
    }
}
