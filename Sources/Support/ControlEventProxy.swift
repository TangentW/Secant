//
//  ControlEventProxy.swift
//  Secant
//
//  Created by Tangent on 2020/6/24.
//

import UIKit

public final class ControlEventProxy<Control, Value>: NSObject where Control: UIControl {
    
    public private(set) var control: Control?

    @inlinable
    public convenience init(control: Control, event: UIControl.Event, keyPath: KeyPath<Control, Value>) {
        self.init(control: control, event: event, getValue: { $0[keyPath: keyPath] })
    }
    
    public init(control: Control, event: UIControl.Event, getValue: @escaping (Control) -> Value) {
        self.control = control
        _getValue = getValue
        super.init()
        control.addTarget(self, action: #selector(_on(sender:)), for: event)
    }

    public func bind(_ binding: Binding<Value>, with transition: Transaction) {
        _callback = { value in
            transition.begin {
                binding.value = value
            }
        }
    }
    
    @objc private func _on(sender: Any) {
        guard let control = sender as? Control else { return }
        _callback?(_getValue(control))
    }
    
    private let _getValue: (Control) -> Value
    private var _callback: ((Value) -> Void)?
}
