//
//  Switch.swift
//  Secant
//
//  Created by Tangent on 2020/6/23.
//

import UIKit

public struct Switch: Equatable {
    
    public init(_ title: String, isOn: Binding<Bool>) {
        _title = title
        _isOn = isOn
        _isOnValue = isOn.value
    }
    
    private let _title: String
    private let _isOn: Binding<Bool>
    private let _isOnValue: Bool
}

extension Switch: Row {
    
    public typealias Cell = UITableViewCell
    
    public var id: String { _title }
    
    public func install(cell: Cell) -> ControlEventProxy<UISwitch, Bool> {
        cell.selectionStyle = .none
        let control = with(UISwitch()) {
            cell.accessoryView = $0
        }
        return .init(control: control, event: .valueChanged, keyPath: \.isOn)
    }
    
    public func render(context: Context) {
        context.cell.textLabel?.text = _title
        context.coordinator.control?.setOn(_isOn.value, animated: true)
        context.coordinator.bind(_isOn, with: transaction)
    }
    
    public func shouldRerender(old: Switch) -> Bool {
        old._title != _title || old._isOn != _isOn
            || (old._isOnValue != _isOn.value && !isInCurrentTransaction)
    }
}
