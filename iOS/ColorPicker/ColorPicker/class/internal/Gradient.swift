import UIKit

struct Gradient {
    let colors: [HSBColor]
    let locations: [CGFloat]
    
    init(colors: [HSBColor], locations: [CGFloat]) {
        // Check parameters
        assert(locations.count >= 2, "There must be at least two locations to create gradient")
        assert(locations.count == colors.count, "The number of colors and number of locations must be equal")
        locations.forEach {
            assert($0 >= 0.0 && $0 <= 1.0, "Location must be between 0 and 1")
        }
        
        // Create a sequence of the pairings, sorted ascending by location value
        let pairs = zip(colors, locations).sorted { $0.1 < $1.1 }
        
        self.colors = pairs.map { $0.0 }
        self.locations = pairs.map { $0.1 }
    }
    
    func color(at ratio: CGFloat) -> HSBColor {
        assert(ratio >= 0.0 && ratio <= 1.0, "Ratio must be between 0 and 1")
        guard let maxIndex = locations.firstIndex(where: {
            return ratio <= $0
        }) else { return colors[locations.endIndex] }
        guard maxIndex > locations.startIndex else { return colors[maxIndex] }
        let minIndex = locations.index(before: maxIndex)
        
        let minLocation = locations[minIndex]
        let maxLocation = locations[maxIndex]
        
        let leftColor = colors[minIndex]
        let rightColor = colors[maxIndex]
        
        var scaledRatio = (ratio - minLocation) / (maxLocation - minLocation)
        guard leftColor != .white else {    // leftColor is white
            let mixedColor = HSBColor.mix(color: leftColor, and: rightColor, ratio: scaledRatio)
            print("result: hue:(\(mixedColor.hue)), saturation:(\(mixedColor.saturation)), brightness:(\(mixedColor.brightness))")
            return mixedColor
        }
        
        if leftColor.hue > rightColor.hue && !leftColor.isGrayscale {
            scaledRatio = 1 - scaledRatio
        }
        if rightColor == .black {
            scaledRatio = 1 - scaledRatio
        }
        let resultColor = HSBColor.between(color: leftColor, and: rightColor, ratio: scaledRatio)
        print("result: hue:(\(resultColor.hue)), saturation:(\(resultColor.saturation)), brightness:(\(resultColor.brightness))")
        return resultColor
    }
}
