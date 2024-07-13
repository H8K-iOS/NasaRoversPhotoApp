import UIKit

protocol RoverBottomSheetDelegate: AnyObject {
    func didSelectRover(_ rover: String)
}

final class RoverBottomSheetViewController: UIViewController {
    //MARK: Constants
    private let rovers = ["All", "Spirit", "Opportunity", "Curiosity", "Perseverance"]
    private let picker = UIPickerView()
    
    //MARK: Variables
    private lazy var cameraTitle = createTitle(text: "Rover")
    private lazy var backButton = createButton(icon: #imageLiteral(resourceName: "Close"), selector: #selector(backButtonTapped))
    private lazy var applyButton = createButton(icon: #imageLiteral(resourceName: "Tick"), selector: #selector(applyButtonTapped))
    private lazy var hStack = createHStack(axis: .horizontal)
    
    weak var delegate: RoverBottomSheetDelegate?
    private var selectedRover: String?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BackgroundColor.backgroundOne.OWcolor
        setupUI()
        
        picker.delegate = self
        picker.dataSource = self
    }
    //MARK: Methods
    
    @objc private func backButtonTapped(){
        self.dismiss(animated: true)
    }
    @objc private func applyButtonTapped() {
        if let selectedRover = selectedRover {
            delegate?.didSelectRover(selectedRover)
        }
        self.dismiss(animated: true)
    }
}

//MARK: - Extensions
private extension RoverBottomSheetViewController {
    func setupUI() {
        self.view.addSubview(hStack)
        hStack.addArrangedSubview(backButton)
        hStack.addArrangedSubview(cameraTitle)
        hStack.addArrangedSubview(applyButton)
        self.view.addSubview(picker)
        
        hStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
        }
        
        applyButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
        }

        
        picker.snp.makeConstraints { make in
            make.top.equalTo(60)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
}

extension RoverBottomSheetViewController: FilterViewControllerProtocol {}

extension RoverBottomSheetViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRover = rovers[row]
    }
}

extension RoverBottomSheetViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        rovers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        rovers.count
    }
}

