//
//  UITableView.UpdateAnimation.swift
//  Secant
//
//  Created by Tangent on 2020/6/21.
//

import UIKit

public extension UITableView {
    
    struct UpdateAnimation {
        
        public let deleteSections: RowAnimation
        public let insertSections: RowAnimation
        public let reloadSections: RowAnimation
        public let deleteRows: RowAnimation
        public let insertRows: RowAnimation
        public let reloadRows: RowAnimation
        
        public init(animation: RowAnimation) {
            self.init(
                deleteSections: animation,
                insertSections: animation,
                reloadSections: animation,
                deleteRows: animation,
                insertRows: animation,
                reloadRows: animation
            )
        }
        
        public init(
            deleteSections: RowAnimation = .automatic,
            insertSections: RowAnimation = .automatic,
            reloadSections: RowAnimation = .automatic,
            deleteRows: RowAnimation = .automatic,
            insertRows: RowAnimation = .automatic,
            reloadRows: RowAnimation = .automatic
        ) {
            self.deleteSections = deleteSections
            self.insertSections = insertSections
            self.reloadSections = reloadSections
            self.deleteRows = deleteRows
            self.insertRows = insertRows
            self.reloadRows = reloadRows
        }
    }
}
