import UIKit
import SnapKit

final class MainViewController: UIViewController {
    //MARK: - Constants
    private let viewModel: MainViewModel
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.register(CardCell.self, forCellReuseIdentifier: CardCell.identifier)
        return  tv
    }()
    
    private let hStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .horizontal
        vs.distribution = .equalSpacing
        return vs
    }()
    
    
    //MARK: - Variables
    private lazy var marsCameraTitle = createLabel(font: 34, text: "MARS.CAMERA")
    private lazy var dateLable = createLabel(font: 17, text: "June 6, 2019")
    private lazy var calendarButton = createCalendarButton(selector: #selector(calendarButtonTapped))
    private lazy var filterRoverButton = createFilterButton(icon: #imageLiteral(resourceName: "Rover.png"),
                                                            selector: #selector(filterRoverButtonTapped))
    
    private lazy var filterCameraButton = createFilterButton(icon: #imageLiteral(resourceName: "Camera.png"),
                                                             selector: #selector(filterCameraButtonTapped))
    
    private lazy var saveFilterButton = createSaveFilterButton(icon: #imageLiteral(resourceName: "Add.png"),
                                                           selector: #selector(saveFilterButtonTapped))
    
    private lazy var historyButton = createHistoryButton(selector: #selector(historyButtonTapped))
    
    private var selectedRover: String?
    private var selectedCamera: String?
    
    //MARK: - Lifecycle
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AccentColors.accentOne.OWColor
        
        setupUI()
        setupLayouts()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setRovers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func setRovers() {
        self.viewModel.onUpdate = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: Buttons
    @objc private func calendarButtonTapped() {
        self.present(DatePickerViewController(), animated: false)
    }
    
    @objc private func filterRoverButtonTapped() {
        let vc = RoverBottomSheetViewController()
        vc.delegate = self
        vc.isModalInPresentation = true
        
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheet.preferredCornerRadius = 50
                    sheet.detents = [.custom(resolver: { context in
                        0.35 * context.maximumDetentValue
                    })]
                } else {
                    navigationController?.present(vc, animated: true)
                }
            }
        } else {
            navigationController?.present(vc, animated: true)
        }
        self.present(vc, animated: true)
    }
    
    @objc private func filterCameraButtonTapped() {
        let vc = CameraBottomSheetViewController()
        vc.delegate = self
        vc.isModalInPresentation = true
        
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheet.preferredCornerRadius = 40
                    sheet.detents = [.custom(resolver: { context in
                        0.35 * context.maximumDetentValue
                    })]
                } else {
                    navigationController?.present(vc, animated: true)
                }
            }
        } else {
            navigationController?.present(vc, animated: true)
        }
        self.present(vc, animated: true)
        
    }
    
    @objc private func saveFilterButtonTapped() {
        print("saveFilterButtonTapped")
    }
    
    @objc private func historyButtonTapped() {
        print("historyButtonTapped")
    }
}

//MARK: - Extensions
private extension MainViewController {
    func setupUI() {
        self.view.addSubview(marsCameraTitle)
        self.view.addSubview(dateLable)
        self.view.addSubview(calendarButton)
        
        self.view.addSubview(hStack)
        hStack.addArrangedSubview(filterRoverButton)
        hStack.addArrangedSubview(filterCameraButton)
        hStack.addArrangedSubview(UIView())
        hStack.addArrangedSubview(saveFilterButton)
    
        self.view.addSubview(tableView)
        self.view.addSubview(historyButton)
    }
    
    func setupLayouts() {
        marsCameraTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.left.equalToSuperview().offset(19)
        }
        
        dateLable.snp.makeConstraints { make in
            make.top.equalTo(marsCameraTitle.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(19)
        }
        
        calendarButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(78)
            make.right.equalToSuperview().offset(-17)
        }
    
        hStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(dateLable.snp.bottom).offset(26)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(202)
            make.left.right.bottom.equalToSuperview()
        }
        
        historyButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.bottom.equalTo(-21)
            make.height.width.equalTo(70)
        }
    }
}

//MARK: - TableView Extensions
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let photo = self.viewModel.rovers[indexPath.row]
        let vm = DetailViewModel(photo)
        let vc = DetailViewController(vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.numbersOfRows())
        return viewModel.numbersOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.selectedBackgroundView = .none
        cell.config(with: viewModel.rovers[indexPath.row])
        return cell
    }
}

extension MainViewController: RoverBottomSheetDelegate {
    func didSelectRover(_ rover: String) {
        self.filterRoverButton.setTitle(rover, for: .normal)
        self.selectedRover = rover
        fetch()
    }
}

extension MainViewController: CameraBottomSheetDelegate {
    func didSelect(_ camera: String) {
        self.filterCameraButton.setTitle(camera, for: .normal)
        
        self.selectedCamera = camera
        fetch()
    }
}

private extension MainViewController {
    func fetch() {
        if let rover = selectedRover, !rover.isAll, let camera = selectedCamera, !camera.isAll {
                viewModel.fetchRoverForNameAndCamera(roverName: rover, cameraType: camera)
        } else if let rover = selectedRover, !rover.isAll {
                viewModel.fetchRoversForName(roverName: rover)
        } else if let camera = selectedCamera, !camera.isAll {
                viewModel.fetchForCamera(cameraName: camera)
            } else {
                viewModel.fetchRoversForName(roverName: "Curiosity")
            }
        }
}
