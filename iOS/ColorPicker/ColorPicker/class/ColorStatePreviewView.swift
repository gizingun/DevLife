import UIKit

class ColorStatePreviewView: UIView {
    /// The display state of a preview view.
    enum State {
        /// Color is not being changed and the preview view is centered at the last modified point
        case inactive
        
        /// The color is still being changed, but preview view center is fixed
        /// This occurs when a touch begins inside but continues outside of it
        /// In this case, the color is changing its brightness
        case activeFixed
        
        /// The color is being actively changed and the preview view center will be updated the current color
        case active
    }
    
    /// The side of the 'ColorSlider' on which to show the preview view
    enum Side {
        case left
        case right
        case top
        case bottom
    }
    
    static let size: CGSize = CGSize(width: 22, height: 22)
    private static let animationDuration: TimeInterval = 0.15
    private static let activeImageSize: CGSize = CGSize(width: 85, height: 72)
    private static let activeColorViewInset: CGFloat = 5
    private static let activeColorSize: CGSize = CGSize(width: 62, height: 62)
    
    var hapticEnabled: Bool = false
    private(set) var lastState: State = .inactive
    private var side: Side
    private let colorView: UIView = UIView()
    private let activeColorView: UIView = UIView()
    private let activeImageView: UIImageView
    
    private var scaleAmounts: [State:CGFloat] = [.inactive: 1.0, .active: 3.44, .activeFixed: 1.1]
    private var offset: CGPoint = .zero
    private var offsetAmount: CGFloat = 76 {
        didSet {
            calculateOffset()
        }
    }
    required init(side: Side = .left) {
        self.side = side
        activeImageView = UIImageView(image: UIImage(named: "imgTextColorPicker"))
        
        super.init(frame: .zero)
        
        isUserInteractionEnabled = false
        backgroundColor = .white
                
        // Borders
        colorView.clipsToBounds = true
        colorView.layer.borderWidth = 1.0
        colorView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        addSubview(colorView)
        
        activeImageView.frame = CGRect(origin: .zero, size: Self.activeImageSize)
        let scale = scaleAmounts[.active] ?? 1
        let scaleTransform = CGAffineTransform(scaleX: 1.0 / scale, y: 1.0 / scale)
        let translationTransform = CGAffineTransform(translationX: -Self.activeImageSize.width / 2, y: -Self.activeImageSize.height / 2)
        let centerTranslationTransform = CGAffineTransform(translationX: 11, y: 11)
        var transform = scaleTransform.concatenating(translationTransform)
        transform = transform.concatenating(centerTranslationTransform)
        activeImageView.transform = transform
        addSubview(activeImageView)
        activeImageView.isHidden = true
        
        activeImageView.addSubview(activeColorView)
        activeColorView.frame = CGRect(origin: CGPoint(x: Self.activeColorViewInset, y: Self.activeColorViewInset), size: Self.activeColorSize)
        activeColorView.clipsToBounds = true
        activeColorView.layer.borderWidth = 1.0
        activeColorView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        activeColorView.layer.cornerRadius = Self.activeColorSize.width / 2
        
        calculateOffset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        let colorViewFrame = bounds.insetBy(dx: 2, dy: 2)
        colorView.frame = colorViewFrame
        colorView.layer.cornerRadius = min(colorViewFrame.width, colorViewFrame.height) / 2
    }
    
    // MARK: Public
    
    func colorChanged(to color: UIColor) {
        colorView.backgroundColor = color
        activeColorView.backgroundColor = color
    }
    
    func transition(to state: State) {
        guard lastState != state else { return }
        if state == .active {
            self.backgroundColor = .clear
            colorView.isHidden = true
            activeImageView.isHidden = false
        }
        UIView.animate(withDuration: Self.animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            switch state {
            // Set the transform based on `scaleAmounts`.
            case .inactive,
                 .activeFixed:
                let scaleAmount = self.scaleAmounts[state] ?? 1
                let scaleTransform = CGAffineTransform(scaleX: scaleAmount, y: scaleAmount)
                self.transform = scaleTransform
                
            // Set the transform based on `scaleAmounts` and `offset`.
            case .active:
                let scaleAmount = self.scaleAmounts[state] ?? 1
                let scaleTransform = CGAffineTransform(scaleX: scaleAmount, y: scaleAmount)
                let translationTransform = CGAffineTransform(translationX: self.offset.x, y: self.offset.y)
                self.transform = scaleTransform.concatenating(translationTransform)
            }
        }, completion: { _ in
            if state != .active {
                self.backgroundColor = .white
                self.colorView.isHidden = false
                self.activeImageView.isHidden = true
            }
        })
        
        if hapticEnabled, #available(iOS 10.0, *) {
            switch (lastState, state) {
            case (.active, .activeFixed):
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            case (.activeFixed, .inactive):
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            default:
                break
            }
        }
        
        lastState = state
    }
}

private extension ColorStatePreviewView {
    func calculateOffset() {
        switch side {
        case .left:
            offset = CGPoint(x: -offsetAmount, y: 0)
        case .right:
            offset = CGPoint(x: offsetAmount, y: 0)
        case .top:
            offset = CGPoint(x: 0, y: -offsetAmount)
        case .bottom:
            offset = CGPoint(x: 0, y: offsetAmount)
        }
    }
}
