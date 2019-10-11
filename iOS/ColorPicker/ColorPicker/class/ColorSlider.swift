import UIKit

class ColorSlider: UIControl {
    static let gradientInset: CGFloat = 9
    enum Orientation {
        case horizontal
        case vertical
    }
    var color: HSBColor {
        return internalColor
    }
    private var internalColor: HSBColor
    private var sliderContainerView: UIView = UIView()
    private let orientation: Orientation
    private let gradientView: GradientColorView
    private let preview: ColorStatePreviewView
    
    required init(orientation: Orientation, side: ColorStatePreviewView.Side) {
        self.orientation = orientation
        internalColor = .white
        gradientView = GradientColorView(orientation: orientation)
        preview = ColorStatePreviewView(side: side)
        
        super.init(frame: .zero)
        addSubview(sliderContainerView)
        sliderContainerView.isUserInteractionEnabled = false
        sliderContainerView.addSubview(gradientView)
        sliderContainerView.addSubview(preview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var containerFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        containerFrame.origin.x = Self.gradientInset
        containerFrame.origin.y = Self.gradientInset
        containerFrame.size.width -= Self.gradientInset * 2
        containerFrame.size.height -= Self.gradientInset * 2
        sliderContainerView.frame = containerFrame
        gradientView.frame = sliderContainerView.bounds
        
        switch orientation {
        case .horizontal where preview.center.y != sliderContainerView.bounds.midY, .vertical where preview.center.x != sliderContainerView.bounds.midX:
            centerPreview(at: .zero)
        case .vertical where autoresizesSubviews, .horizontal where autoresizesSubviews:
            preview.bounds.size = ColorStatePreviewView.size
        default:
            break
        }
    }
}

// MARK: UIControlEvents

extension ColorSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        // Reset brightness
        internalColor.brightnessRatio = 1.0
        update(touch: touch, touchInside: true)
        
        let touchLocation = touch.location(in: sliderContainerView)
        centerPreview(at: touchLocation)
        preview.transition(to: .active)
        
        sendActions(for: .touchDown)
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)

        if isTouchInside == false {
            preview.transition(to: .activeFixed)
        }
        
        if preview.lastState == .activeFixed {
            update(touch: touch, touchInside: false)
            // TODO: 작업
        } else if preview.lastState == .active {
            update(touch: touch, touchInside: true)
            let touchLocation = touch.location(in: sliderContainerView)
            centerPreview(at: touchLocation)
        }
        
        /*
         if isTouchInside {
         update(touch: touch, touchInside: true)
         let touchLocation = touch.location(in: sliderContainerView)
         centerPreview(at: touchLocation)
         } else {
         update(touch: touch, touchInside: false)
         let touchLocation = touch.location(in: sliderContainerView)
         preview.transition(to: .activeFixed)
         //            print("touchLocation outside : \(touchLocation)")
         }
         */

        
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        guard let endTouch = touch else { return }
        if preview.lastState == .active {
            update(touch: endTouch, touchInside: true)
        } else if preview.lastState == .activeFixed {
            update(touch: endTouch, touchInside: false)
        }
        preview.transition(to: .inactive)
    }
}

extension ColorSlider {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden else { return super.hitTest(point, with: event) }
        let minimumSideLength: CGFloat = 44
        let padding: CGFloat = -20
        let dx: CGFloat = min(bounds.width - minimumSideLength, padding)
        let dy: CGFloat = min(bounds.height - minimumSideLength, padding)
        // If an increased tappable area is needed, respond appropriately
        let increasedTapAreaNeeded = (dx < 0 || dy < 0)
        let expandedBounds = bounds.insetBy(dx: dx / 2, dy: dy / 2)
        
        if increasedTapAreaNeeded && expandedBounds.contains(point) {
            for subview in subviews.reversed() {
                let convertedPoint = subview.convert(point, from: self)
                if let hitTestView = subview.hitTest(convertedPoint, with: event) {
                    return hitTestView
                }
            }
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

// MARK: Private

private extension ColorSlider {
    func centerPreview(at point: CGPoint) {
        switch orientation {
        case .vertical:
            let boundedTouchY = (0..<sliderContainerView.bounds.height).clamp(point.y)
            preview.center = CGPoint(x: sliderContainerView.bounds.midX, y: boundedTouchY)
        case .horizontal:
            let boundedTouchX = (0..<sliderContainerView.bounds.width).clamp(point.x)
            preview.center = CGPoint(x: boundedTouchX, y: sliderContainerView.bounds.midY)
        }
    }
    
    func update(touch: UITouch, touchInside: Bool) {
        internalColor = gradientView.color(from: internalColor, after: touch, insideSlider: touchInside)
        preview.colorChanged(to: internalColor.uiColor)
    }
}
