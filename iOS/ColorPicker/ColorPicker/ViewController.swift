//
//  ViewController.swift
//  ColorPicker
//
//  Created by simon on 09/10/2019.
//  Copyright © 2019 gizingun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let demoView = DemoView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(demoView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        demoView.frame = view.frame
    }
}

