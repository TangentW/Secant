//
//  Check.swift
//  Secant
//
//  Created by Tangent on 2020/6/29.
//

import UIKit

public struct Check: Equatable {
    
    public init(_ text: String, isSelected: Bool) {
        _text = text
        _isSelected = isSelected
    }

    private let _text: String
    private let _isSelected: Bool
}

extension Check: Row {

    public var id: String { _text }
    
    public func render(context: Context) {
        context.cell.textLabel?.text = _text
        context.cell.accessoryType = _isSelected ? .checkmark : .none
    }
}
