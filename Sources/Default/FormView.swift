//
//  FormView.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

import UIKit

public class FormView: UITableView {
    
    private var _renderer: Renderer?
    
    public init(form: Form, frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        _renderer = DefaultRenderer(tableView: self)
        _renderer?.render(form)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
