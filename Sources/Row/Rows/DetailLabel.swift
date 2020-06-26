//
//  DetailLabel.swift
//  Secant
//
//  Created by Tangent on 2020/6/24.
//

import UIKit

public struct DetailLabel: Equatable {
    
    public init(title: String, detail: String) {
        _title = title
        _detail = detail
    }
    
    private let _title: String
    private let _detail: String
}

extension DetailLabel: Row {

    public var id: String { _title }
    
    public func render(context: Context) {
        with(context.cell) {
            $0.textLabel?.text = _title
            $0.detailTextLabel?.text = _detail
        }
    }
}

public extension DetailLabel {
    
    final class Cell: UITableViewCell {
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
