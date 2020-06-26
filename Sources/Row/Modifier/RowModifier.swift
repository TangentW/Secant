//
//  RowModifier
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import UIKit

public protocol RowModifier: Row where Coordinator == Content.Coordinator {
    
    associatedtype Content: Row

    var content: Content { get }
}

public extension RowModifier {
    
    @inlinable
    var id: Content.ID { content.id }

    @inlinable
    var cellType: UITableViewCell.Type {
        content.cellType
    }
    
    @inlinable
    var reuseId: String { content.reuseId }
    
    @inlinable
    func install(cell: Content.Cell) -> Content.Coordinator {
        content.install(cell: cell)
    }
    
    @inlinable
    func render(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        content.render(context: context)
    }
    
    @inlinable
    func shouldRerender(old: Self) -> Bool {
        content.shouldRerender(old: old.content)
    }
    
    @inlinable
    var height: CGFloat? { content.height }
    
    @inlinable
    func didSelect(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        content.didSelect(context: context)
    }
    
    @inlinable
    func willDisplay(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        content.willDisplay(context: context)
    }
    
    @inlinable
    func didEndDisplaying(context: Context) {
        guard let context = context.map(rowType: Content.self) else { return }
        content.didEndDisplaying(context: context)
    }
}
