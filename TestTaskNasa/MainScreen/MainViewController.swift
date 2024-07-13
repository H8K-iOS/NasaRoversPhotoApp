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
    private lazy var dateLable = createLabel(font: 17, text: "")
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
    private var selectedDate: Date?
    
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
                self?.updateDateLabel()
            }
        }
    }
    
    func updateDateLabel() {
        if viewModel.currentDate == nil {
            guard let rovers = viewModel.rovers.first else { return }
            self.dateLable.text = formatDateString(rovers.earthDate)
        } else {
            guard let rovers = viewModel.roversPhoto.first else { return }
            self.dateLable.text = formatDateString(rovers.earthDate)
        }
            
    }
    
    func formatDateString(_ dateString: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           
           if let date = dateFormatter.date(from: dateString) {
               dateFormatter.dateFormat = "MMMM d, yyyy"
               return dateFormatter.string(from: date)
           }
           return dateString
       }
    
    //MARK: Buttons
    @objc private func calendarButtonTapped() {
        let vc = DatePickerViewController()
        vc.delegate = self
        self.present(vc, animated: false)
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
        if viewModel.currentDate == nil {
            cell.config(with: viewModel.rovers[indexPath.row])
        } else {
            cell.config(with: viewModel.roversPhoto[indexPath.row])
        }
        
        cell.selectionStyle = .none
        cell.selectedBackgroundView = .none
        
        
        
        return cell
    }
}

//MARK: - Filters Delegates
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

extension MainViewController: DatePickerViewControllerDelegate {
    func dateDidSelected(_ date: Date) {
        self.selectedDate = date
        
        let dateFormaterForLable = DateFormatter()
        dateFormaterForLable.dateFormat = "MMMM d, yyyy"
        let dateFormaterForReq = DateFormatter()
        dateFormaterForReq.dateFormat = "yyyy-MM-dd"
        
        let formatedDate = dateFormaterForLable.string(from: date)
        let formatedDateForReq = dateFormaterForReq.string(from: date)
        self.dateLable.text = formatedDate
        
        
        self.viewModel.fetchForDate(date: formatedDateForReq)
    }
    
    
}

private extension MainViewController {
    func fetch() {
           let roverSelected = selectedRover != nil && !selectedRover!.isAll
           let cameraSelected = selectedCamera != nil && !selectedCamera!.isAll
           let dateSelected = selectedDate != nil
           
           if roverSelected && cameraSelected && dateSelected {
               let rover = selectedRover!
               let camera = selectedCamera!
               let date = formattedDateForReq(from: selectedDate!)
               viewModel.fetchRoverForAllfilters(roverName: rover, cameraType: camera, date: date)
           } else if roverSelected && cameraSelected {
               let rover = selectedRover!
               let camera = selectedCamera!
               viewModel.fetchRoverForNameAndCamera(roverName: rover, cameraType: camera)
           } else if roverSelected && dateSelected {
               let rover = selectedRover!
               let date = formattedDateForReq(from: selectedDate!)
               viewModel.fetchForRoverAndDate(roverName: rover, date: date)
           } else if cameraSelected && dateSelected {
               let camera = selectedCamera!
               let date = formattedDateForReq(from: selectedDate!)
               viewModel.fetchForCameraAndDate(cameraType: camera, date: date)
           } else if roverSelected {
               let rover = selectedRover!
               viewModel.fetchRoversForName(roverName: rover)
           } else if cameraSelected {
               let camera = selectedCamera!
               viewModel.fetchForCamera(cameraName: camera)
           } else if dateSelected {
               let date = formattedDateForReq(from: selectedDate!)
               viewModel.fetchForDate(date: date)
           } else {
               viewModel.fetchRoversForName(roverName: "Curiosity")
           }
       }
    
    func formattedDateForReq(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
}
