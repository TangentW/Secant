//
//  Label.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import UIKit

public struct Label: Equatable {
    
    public init(_ text: String) {
        _text = text
    }
    
    private let _text: String
}

extension Label: Row {

    public var id: String { _text }
    
    public func render(context: Context) {
        context.cell.textLabel?.text = _text
    }
}
