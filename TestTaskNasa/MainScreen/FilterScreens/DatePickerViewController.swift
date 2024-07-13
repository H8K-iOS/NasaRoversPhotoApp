import UIKit
import SnapKit

protocol DatePickerViewControllerDelegate {
    func dateDidSelected(_ date: Date)
}

final class DatePickerViewController: UIViewController {
    //MARK: Constants
    private let container = UIView()
    private lazy var backButton = createButton(icon: #imageLiteral(resourceName: "Close"), selector: #selector(backButtonTapped))
    private lazy var applyButton = createButton(icon: #imageLiteral(resourceName: "Tick.png"), selector: #selector(applyButtonTapped))
    private lazy var dateTitle = createTitle(text: "Date")
    private lazy var hStack = createHStack(axis: .horizontal)
    //MARK: Variables
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LayerColors.layerOne.OWColor.withAlphaComponent(0.4)
        setupContainer()
        setupUI()
    }
    //MARK: Methods
    
    @objc private func backButtonTapped(){
        self.dismiss(animated: false)
    }
    @objc private func applyButtonTapped() {
        
    }
}

//MARK: - Extensions
private extension DatePickerViewController {
    func setupContainer() {
        self.view.addSubview(container)
        container.backgroundColor = BackgroundColor.backgroundOne.OWcolor
        container.layer.cornerRadius = 35
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(312)
        }
    }
    
    func setupUI() {
        container.addSubview(hStack)
        hStack.addArrangedSubview(backButton)
        hStack.addArrangedSubview(dateTitle)
        hStack.addArrangedSubview(applyButton)
        
        hStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
           
        }
    }
}

extension DatePickerViewController: FilterViewControllerProtocol {}
