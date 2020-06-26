//
//  Switch.swift
//  Secant
//
//  Created by Tangent on 2020/6/23.
//

import UIKit

public struct Switch: Equatable {
    
    public init(title: String, isOn: Binding<Bool>) {
        _title = title
        _isOn = isOn
    }
    
    private let _title: String
    private let _isOn: Binding<Bool>
}

extension Switch: Row {
    
    public typealias Cell = UITableViewCell
    
    public var id: String { _title }
    
    public func install(cell: Cell) -> ControlEventProxy<UISwitch, Bool> {
        let control = with(UISwitch()) {
            cell.accessoryView = $0
        }
        return .init(control: control, event: .valueChanged, keyPath: \.isOn)
    }
    
    public func render(context: Context) {
        context.cell.textLabel?.text = _title
        context.coordinator.control?.isOn = _isOn.value
        context.coordinator.bind(_isOn)
    }
}
