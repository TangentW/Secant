//
//  Form.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import Foundation

public protocol Form {
    
    var rows: Rows { get }
    var sections: Sections { get }
}

public extension Form {
    
    var rows: Rows {
        fatalError("rows has not been implemented")
    }
    
    var sections: Sections {
        [Section(id: UUID(), rows: rows._rows)]
    }
}

internal extension Form {
    
    var updatePublishers: [UpdatePublisher] {
        Mirror(reflecting: self).children.compactMap { $0.value as? UpdatePublisher }
    }
}

public extension Renderer {
    
    func render(_ form: Form) {
        self[associated: _formUpdateCancelKey].take()?.cancel()
        let update: () -> Void = { [weak self] in
            self?.render(form.sections._sections)
        }
        let updateCancels = form.updatePublishers.map {
            $0.listen(update: update)
        }
        self[associated: _formUpdateCancelKey] = Cancels.new(updateCancels)
        update()
    }
    
    func invalidateForm() {
        self[associated: _formUpdateCancelKey].take()?.cancel()
    }
}

private let _formUpdateCancelKey = AssociatedKey<Cancellable>()
