//
//  Label.swift
//  Secant
//
//  Created by Tangent on 2020/6/22.
//

import UIKit

public struct Label: Equatable {
    
    public init(_ text: String, image: UIImage? = nil, detail: String? = nil) {
        _image = image
        _text = text
        _detailText = detail
    }
    
    public func image(_ image: UIImage?) -> Label {
        .init(_text, image: image, detail: _detailText)
    }
    
    public func detail(_ detailText: String?) -> Label {
        .init(_text, image: _image, detail: detailText)
    }
    
    private let _image: UIImage?
    private let _text: String
    private let _detailText: String?
}

extension Label: Row {
    
    public var id: String { _text }
    
    public func render(context: Context) {
        context.cell.set(image: _image, text: _text, detailText: _detailText)
    }
}

public extension Label {
    
    final class Cell: UITableViewCell {
        
        public func set(image: UIImage?, text: String?, detailText: String?) {
            imageView?.image = image
            textLabel?.text = text
            detailTextLabel?.text = detailText
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
