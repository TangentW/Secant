//
//  ViewController.swift
//  Demo
//
//  Created by Tangent on 2020/6/24.
//  Copyright © 2020 Tangent. All rights reserved.
//

import UIKit
import Secant

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        present(FormViewController(form: DemoForm()), animated: true, completion: nil)
    }
}

let viewController = FormViewController(form: DemoForm())

struct DemoForm: Form {
    
    @State
    var isExpanded = false
    
    @State
    var isEnabled = true
    
    @State
    var isHidden = false

    @RowsBuilder
    var rows: Rows {
        Switch(title: "Hide", isOn: $isHidden)
        
        if !isHidden {
            Switch(title: "Expand", isOn: $isExpanded)
            Switch(title: "Toggle", isOn: $isEnabled)
                .onRender {
                    $0.cell.textLabel?.textColor = .red
            }
        }

        Label("Hello World")
            .detail(isEnabled ? "⭕️" : "❌")
            .height(isExpanded ? 150 : 50)
            .onDidSelect {
                print("DidSelect")
                $0.tableView.deselectRow(at: $0.indexPath, animated: true)
            }
    }
}
