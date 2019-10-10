import UIKit

/*
 class ColorStateView: UIView {
 private static let size = CGSize(width: 85, height: 72)
 private static let inactiveSize = CGSize(width: 22, height: 22)
 
 private var circleView: UIView!
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 
 let imageView = UIImageView(image: UIImage(named: "imgTextColorPicker"))
 addSubview(imageView)
 imageView.frame = CGRect(origin: .zero, size: Self.size)
 
 let circleSize = CGSize(width: 62, height: 62)
 let circleView = UIView(frame: CGRect(x: 5, y: 5, width: circleSize.width, height: circleSize.height))
 circleView.backgroundColor = UIColor.white
 circleView.layer.cornerRadius = circleSize.width / 2.0
 circleView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
 circleView.layer.borderWidth = 1.0 / UIScreen.main.scale
 
 self.circleView = circleView
 addSubview(circleView)
 // TODO: add Shadow
 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 func setColor(_ color: UIColor) {
 circleView.backgroundColor = color
 }
 }
 
 fileprivate extension UIImage {
 class func sliderThumb(size: CGSize, withColor color: UIColor) -> UIImage? {
 UIGraphicsBeginImageContextWithOptions(size, false, 0)
 let context = UIGraphicsGetCurrentContext()
 context?.saveGState()
 
 let rect = CGRect(origin: .zero, size: size)
 context?.setFillColor(UIColor.white.cgColor)
 context?.fillEllipse(in: rect)
 
 let innerRect = CGRect(x: 2.0, y: 2.0, width: size.width - 4.0, height: size.height - 4.0)
 context?.setFillColor(color.cgColor)
 context?.fillEllipse(in: innerRect)
 
 let path = CGPath(ellipseIn: innerRect, transform: nil)
 context?.setStrokeColor(UIColor.black.withAlphaComponent(0.3).cgColor)
 context?.addPath(path)
 context?.drawPath(using: .fillStroke)
 
 context?.restoreGState()
 let image = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext()
 return image
 }
 }
 */
