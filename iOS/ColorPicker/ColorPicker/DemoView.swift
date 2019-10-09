//
//  DemoView.swift
//  ColorPicker
//
//  Created by simon on 09/10/2019.
//  Copyright © 2019 gizingun. All rights reserved.
//

import UIKit

class DemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
