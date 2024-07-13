import UIKit

enum BackgroundColor: Int {
    case backgroundOne
    
    var OWcolor: UIColor {
        switch self {
        case .backgroundOne:
            #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        }
        
    }
}

enum AccentColors {
    case accentOne
    
    var OWColor: UIColor {
        switch self {
        case .accentOne:
            #colorLiteral(red: 1, green: 0.4102588296, blue: 0.1710044444, alpha: 1)
        }
    }
}

enum LayerColors {
    case layerOne, layerTwo
    
    var OWColor: UIColor {
        switch self {
        case .layerOne:
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .layerTwo:
            #colorLiteral(red: 0.6286745071, green: 0.6286745071, blue: 0.6286745071, alpha: 1)
        }
    }
}

enum SystemColors {
    case systemTwo, systemThree
    
    var OWColor: UIColor {
        switch self {
        case .systemTwo:
            #colorLiteral(red: 0, green: 0.4800075889, blue: 1, alpha: 1)
        case .systemThree:
            #colorLiteral(red: 1, green: 0.231820792, blue: 0.1873916984, alpha: 1)
        }
    }
}
