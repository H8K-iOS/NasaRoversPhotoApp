import Foundation
import UIKit

extension String {
    var isAll: Bool {
        return self == "All"
    }
    
    static func labelColor(title: String, value: String) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: UIColor.gray
        ])
        str.append(NSAttributedString(string: value, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.black
        ]))
        
        return str
    }
}





