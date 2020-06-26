//
//  FormViewController.swift
//  Secant
//
//  Created by Tangent on 2020/6/26.
//

import UIKit

public class FormViewController: UITableViewController {
    
    private let _form: Form
    private var _renderer: Renderer?
    
    public init(form: Form, style: UITableView.Style = .plain) {
        _form = form
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        _renderer = DefaultRenderer(tableView: tableView)
        _renderer?.render(_form)
    }
}
