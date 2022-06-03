import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    enum SampleCase: String, CaseIterable {
        case simpleImageFilter = "SimpleImageFilter"
    }
    
    let sampleCases: [SampleCase] = SampleCase.allCases
    
    struct Input {
        
    }
}
