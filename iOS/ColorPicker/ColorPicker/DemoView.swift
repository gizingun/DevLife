//
//  DemoView.swift
//  ColorPicker
//
//  Created by simon on 09/10/2019.
//  Copyright © 2019 gizingun. All rights reserved.
//

import UIKit

class DemoView: UIView {
    private let colorSlider: ColorSlider
    
    override init(frame: CGRect) {
        colorSlider = ColorSlider(orientation: .vertical, side: .left)
        
        super.init(frame: frame)
        backgroundColor = .gray
        
        colorSlider.addTarget(self, action: #selector(changedColor(slider:)), for: .valueChanged)
        addSubview(colorSlider)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Event
    
    @objc func changedColor(slider: ColorSlider) {
        print("slider changed color: \(slider.color) - hue(\(slider.color.hue)), saturation(\(slider.color.saturation)), brightness(\(slider.color.brightness)), brightnessRatio(\(slider.color.brightnessRatio))")
    }
}

private extension DemoView {
    func setupConstraints() {
        let colorSliderHeight: CGFloat = 178 + ColorSlider.gradientInset * 2
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            colorSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            colorSlider.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorSlider.widthAnchor.constraint(equalToConstant: 4 + ColorSlider.gradientInset * 2),
            colorSlider.heightAnchor.constraint(equalToConstant: colorSliderHeight),
        ])
    }
}
