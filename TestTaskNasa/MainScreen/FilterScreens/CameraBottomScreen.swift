import UIKit
protocol CameraBottomSheetDelegate: AnyObject {
    func didSelect(_ camera: String)
}

final class CameraBottomSheetViewController: UIViewController {
    //MARK: Constants
    private let cameras = ["All", "Front Hazard Avoidance Camera",
                           "Rear Hazard Avoidance Camera",
                           "Mast Camera",
                           "Chemistry and Camera Complex",
                           "Mars Hand Lens Imager",
                           "Mars Descent Imager",
                           "Navigation Camera",
                           "Panoramic Camera",
                           "Miniature Thermal Emission Spectrometer (Mini-TES)"
    ]
    
    private let cameraShrtName: [String: String] = [
            "All": "All",
            "Front Hazard Avoidance Camera": "FHAZ",
            "Rear Hazard Avoidance Camera": "RHAZ",
            "Mast Camera": "MAST",
            "Chemistry and Camera Complex": "CHEMCAM",
            "Mars Hand Lens Imager": "MAHLI",
            "Mars Descent Imager": "MARDI",
            "Navigation Camera": "NAVCAM",
            "Panoramic Camera": "PANCAM",
            "Miniature Thermal Emission Spectrometer (Mini-TES)": "MINITES"
        ]
    
    private let picker = UIPickerView()
    
    
    //MARK: Variables
    private lazy var cameraTitle = createTitle(text: "Camera")
    private lazy var backButton = createButton(icon: #imageLiteral(resourceName: "Close"), selector: #selector(backButtonTapped))
    private lazy var applyButton = createButton(icon: #imageLiteral(resourceName: "Tick"), selector: #selector(applyButtonTapped))
    private lazy var hStack = createHStack(axis: .horizontal)
    
    weak var delegate: CameraBottomSheetDelegate?
    private var selectedCamera: String?
    
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
        if let selectedCamera = selectedCamera, let shrtName = cameraShrtName[selectedCamera] {
            delegate?.didSelect(shrtName)
        }
        self.dismiss(animated: true)
    }
}

//MARK: - Extensions
private extension CameraBottomSheetViewController {
    func setupUI() {
        self.view.addSubview(picker)
        self.view.addSubview(hStack)
        hStack.addArrangedSubview(backButton)
        hStack.addArrangedSubview(cameraTitle)
        hStack.addArrangedSubview(applyButton)
        
        
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

extension CameraBottomSheetViewController: FilterViewControllerProtocol {}

extension CameraBottomSheetViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCamera = cameras[row]
    }
}

extension CameraBottomSheetViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cameras.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        cameras[row]
    }
    
}
