//
//  HeaderFooterContext.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

import UIKit

public enum HeaderFooterType {
    
    case header(section: Int)
    case footer(section: Int)
    
    public var section: Int {
        switch self {
        case .header(let section):
            return section
        case .footer(let section):
            return section
        }
    }
}

public struct HeaderFooterContext<Content> where Content: HeaderFooter {
    
    public let coordinator: Content.Coordinator
    public let view: Content.View
    public let tableView: UITableView
    public let type: HeaderFooterType
    
    @inlinable
    internal init(coordinator: Content.Coordinator, view: Content.View, tableView: UITableView, type: HeaderFooterType) {
        self.coordinator = coordinator
        self.view = view
        self.tableView = tableView
        self.type = type
    }
}

public extension HeaderFooterContext {
    
    func map<HF>(headerFooterType: HF.Type) -> HeaderFooterContext<HF>? {
        guard let coordinator = coordinator as? HF.Coordinator, let view = view as? HF.View else { return nil }
        return .init(coordinator: coordinator, view: view, tableView: tableView, type: type)
    }
}
