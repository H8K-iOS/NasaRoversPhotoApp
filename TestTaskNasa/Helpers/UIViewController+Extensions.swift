import UIKit
import SnapKit

extension MainViewController  {
    func createLabel(font: CGFloat, text: String) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.font = .systemFont(ofSize: font, weight: .bold)
        lb.textColor = .black
        return lb
    }
    
    func createCalendarButton(selector: Selector) -> UIButton {
        let btn = CustomCalendarButton()
        btn.setImage(UIImage(#imageLiteral(resourceName: "Calendar.png")), for: .normal)
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.addTarget(self, action: selector, for: .touchUpInside)
        
        btn.snp.makeConstraints { make in
            make.height.width.equalTo(44)
        }
        btn.addTarget(self, action: selector, for: .touchUpInside)
        return btn
    }
    
    func createFilterButton(icon: UIImage, selector: Selector) -> UIButton {
        let btn = UIButton()
        btn.setImage(icon, for: .normal)
        btn.setTitle("All", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.backgroundColor = BackgroundColor.backgroundOne.OWcolor
        btn.layer.cornerRadius = 12
        btn.tintColor = .black
        btn.contentHorizontalAlignment = .leading
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        
        btn.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(38)
        }
        return btn
    }
    
    func createSaveFilterButton(icon: UIImage, selector: Selector) -> UIButton {
        let btn = UIButton()
        btn.setImage(icon, for: .normal)
        btn.backgroundColor = BackgroundColor.backgroundOne.OWcolor
        btn.layer.cornerRadius = 12
        btn.tintColor = .black
        btn.addTarget(self, action: selector, for: .touchUpInside)
        
        btn.snp.makeConstraints { make in
            make.height.width.equalTo(38)
        }
        
        return btn
    }
    
    func createHistoryButton(selector: Selector) -> UIButton {
        let btn = RoundButton()
        btn.setImage(UIImage(#imageLiteral(resourceName: "History.png")), for: .normal)
        btn.backgroundColor = AccentColors.accentOne.OWColor
        btn.addTarget(self, action: selector, for: .touchUpInside)
        
        return btn
    }

}

extension DetailViewController {
    func createBackBarButton(selector: Selector) -> UIBarButtonItem {
        let btn = UIBarButtonItem(image: #imageLiteral(resourceName: "CloseclosClear"), style: .plain, target: self, action: selector)
        btn.tintColor = .white
        return btn
    }
}

//MARK: - Bottom Sheets

protocol FilterViewControllerProtocol {
    func createButton(icon: UIImage, selector: Selector) -> UIButton
    func createTitle(text: String) -> UILabel
    func createHStack(axis: NSLayoutConstraint.Axis) -> UIStackView
}

extension FilterViewControllerProtocol where Self: UIViewController {
    func createButton(icon: UIImage, selector: Selector) -> UIButton {
        let btn = UIButton()
        btn.setImage(icon, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: selector, for: .touchUpInside)
        return btn
    }
    
    func createTitle(text: String) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 22)
        return lb
    }
    
    func createHStack(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let sv = UIStackView()
        sv.axis = axis
        sv.distribution = .equalSpacing
        return sv
    }
}

