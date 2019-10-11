import UIKit

class GradientColorView: UIView {
    let orientation: ColorSlider.Orientation
    private var gradient: Gradient {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init(orientation: ColorSlider.Orientation) {
        self.orientation = orientation
        self.gradient = Gradient.colorSliderGradient()
//        self.gradient = Gradient.colorSliderGradient(saturation: 1, whiteInset: 0.15, blackInset: 0.15)
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        switch orientation {
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        gradientLayer.masksToBounds = true
        gradientLayer.cornerRadius = 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: Public
    
    func color(from oldColor: HSBColor, after touch: UITouch, insideSlider: Bool) -> HSBColor {
        var color = oldColor
        if insideSlider {
            let progress = touch.progress(in: self, withOrientation: orientation)
            color = calculateColor(for: progress)
        } else {
            let horizontalPercent = touch.progress(withOrientation: .horizontal)
            let verticalPercent = touch.progress(withOrientation: .vertical)
            switch orientation {
            case .vertical:
                color.brightnessRatio = horizontalPercent
            case .horizontal:
                color.brightnessRatio = verticalPercent
            }
        }
        
        return color
    }
}

// MARK: Layer and Drawing

extension GradientColorView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            fatalError("GradientColorView Layer must be a CAGradientLayer")
        }
        return gradientLayer
    }
    
    override func draw(_ rect: CGRect) {
        gradientLayer.colors = gradient.colors.map({ (hsbColor) -> CGColor in
            return UIColor(hsbColor: hsbColor).cgColor
        })
        gradientLayer.locations = gradient.locations as [NSNumber]
    }
}

private extension GradientColorView {
    func calculateColor(for sliderProgress: CGFloat) -> HSBColor {
        return gradient.color(at: sliderProgress)
    }
}

fileprivate extension Gradient {
    static func colorSliderGradient(saturation: CGFloat, whiteInset: CGFloat, blackInset: CGFloat) -> Gradient {
        let values: [CGFloat] = [0.01, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99]
        let hues = values
        
        // non-white and non-black colors
        let nonGrayscaleColors = hues.map { HSBColor(hue: $0, saturation: saturation, brightness: 1)}.reversed()
        
        let spaceForNonGrayscaleColors = 1 - whiteInset - blackInset
        let nonGrayscaleLocations = values.map { (location) -> CGFloat in
            return whiteInset + (location * spaceForNonGrayscaleColors)
        }
        
        let colors = [HSBColor.white] + nonGrayscaleColors + [HSBColor.black]
        let locations = [0] + nonGrayscaleLocations + [1]
        return Gradient(colors: colors, locations: locations)
    }
    
    static func colorSliderGradient() -> Gradient {
        let originalColors: [UIColor] = [
        UIColor.white,
        UIColor(red: 255, green: 21, blue: 187),
        UIColor(red: 142, green: 0, blue: 255),
        UIColor(red: 29, green: 51, blue: 225),
        UIColor(red: 34, green: 171, blue: 255),
        UIColor(red: 133, green: 255, blue: 37),
        UIColor(red: 255, green: 255, blue: 0),
        UIColor(red: 255, green: 103, blue: 0),
        UIColor(red: 255, green: 0, blue: 0),
        UIColor.black
        ]
        
        let locations = originalColors.enumerated().map { (index, color) -> CGFloat in
            guard index > 0 && index < originalColors.count - 1 else {
                if index == 0 { return 0 }
                return 1
            }
            return 1.0 / CGFloat(originalColors.count - 1) * CGFloat(index)
        }
        let hsbColors = originalColors.map { HSBColor(color: $0) }
        return Gradient(colors: hsbColors, locations: locations)
    }
}

fileprivate extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

fileprivate extension UITouch {
    func progress(in view: UIView, withOrientation orientation: ColorSlider.Orientation) -> CGFloat {
        let touchLocation = self.location(in: view)
        var progress: CGFloat = 0
        
        switch orientation {
        case .vertical:
            progress = touchLocation.y / view.bounds.height
        case .horizontal:
            progress = touchLocation.x / view.bounds.width
        }
        
        return (0.0..<1.0).clamp(progress)
    }
    
    func progress(withOrientation orientation: ColorSlider.Orientation) -> CGFloat {
        let lengthMargin: CGFloat = 50
        let controlInset: CGFloat = 70
        let maxProgress: CGFloat = 1
        
        guard let view = self.view else { return 1 }
        let location = self.location(in: view)
        switch orientation {
        case .horizontal: // Caculate right to left movement
            let baseLength = view.frame.origin.x - lengthMargin - controlInset
            guard baseLength > lengthMargin else { return 1 }
            var movement = min(0, location.x + controlInset)
            movement = (0..<baseLength).clamp(abs(movement))
            
            let progress: CGFloat = (0..<maxProgress).clamp(movement/baseLength)
            return maxProgress - progress
        case .vertical: // Caculate bottom to up movement
            let baseLength = view.frame.origin.y - lengthMargin - controlInset
            guard baseLength > lengthMargin else { return 1 }
            var movement = min(0, location.y + controlInset)
            movement = (0..<baseLength).clamp(abs(movement))
            
            let progress: CGFloat = (0..<maxProgress).clamp(movement/baseLength)
            return maxProgress - progress
        }
    }
}
