import UIKit

class ColorSlider: UIControl {
    enum Orientation {
        case horizontal
        case vertical
    }
    
    let orientation: Orientation
    private let gradientView: GradientColorView
    
    required init(orientation: Orientation) {
        self.orientation = orientation
        gradientView = GradientColorView(orientation: orientation)
        
        super.init(frame: .zero)
        
        addSubview(gradientView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientView.frame = bounds
    }
}

// MARK: UIControlEvents

extension ColorSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        print("beginTracking")
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        if isTouchInside {
            let touchLocation = touch.location(in: self)
            print("touchLocation inside : \(touchLocation)")
        } else {
            let touchLocation = touch.location(in: self)
            print("touchLocation outside : \(touchLocation)")
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        print("endTracking")
    }
}
