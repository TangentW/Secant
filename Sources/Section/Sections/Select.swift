//
//  Select.swift
//  Secant
//
//  Created by Tangent on 2020/6/29.
//

import UIKit

public struct Select<Item, Content> where Item: Identifiable, Content: Row {
    
    public typealias BuildContent = (Item, Bool) -> Content
    public typealias Selection = Set<Item.ID>
    
    public init<ID, Items>(
        id: ID,
        selection: Binding<Selection>,
        items: Items,
        isSingleSelection: Bool = false,
        buildContent: @escaping BuildContent
    ) where ID: Hashable, Items: Collection, Items.Element == Item {
        _id = id
        _selection = selection
        _items = Array(items)
        _isSingleSelection = isSingleSelection
        _buildContent = buildContent
    }

    private let _id: AnyHashable
    private let _selection: Binding<Selection>
    private let _items: [Item]
    private let _isSingleSelection: Bool
    private let _buildContent: BuildContent
}

extension Select: Sections {
    
    public var _sections: [Section] { [_section] }
    
    private var _section: Section {
        Section(id: _id) {
            ForEach(_items) { item in
                _buildContent(item, _isSelected(item))
                    .onDidSelect {
                        self._select(item)
                        $0.tableView.deselectRow(at: $0.indexPath, animated: true)
                    }
            }
        }
    }
    
    private func _isSelected(_ item: Item) -> Bool {
        _selection.value.contains(item.id)
    }
    
    private func _select(_ item: Item) {
        let id = item.id
        if _isSingleSelection {
            guard _selection.value != [id] else { return }
            _selection.value = [id]
        } else {
            if _selection.value.contains(id) {
                _selection.value.remove(id)
            } else {
                _selection.value.insert(id)
            }
        }
    }
}
