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

struct DemoForm: Form {
    
    @State
    var isExpanded = false
    
    @RowsBuilder
    var rows: Rows {
        Switch(title: "Toggle", isOn: $isExpanded)
        Label("Hello World").height(isExpanded ? 150 : 50)
    }
}
