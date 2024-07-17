import UIKit
import SnapKit
import Lottie

final class MainViewController: UIViewController {
    // MARK: - Constants
    private let viewModel: MainViewModel
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = BackgroundColor.backgroundOne.OWcolor
        tv.separatorStyle = .none
        tv.register(CardCell.self, forCellReuseIdentifier: CardCell.identifier)
        return tv
    }()
    
    private let hStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .horizontal
        vs.distribution = .equalSpacing
        return vs
    }()
    
    // MARK: - Variables
    private lazy var marsCameraTitle = createLabel(font: 34, weight: .bold, text: "MARS.CAMERA")
    private lazy var dateLable = createLabel(font: 17, weight: .bold, text: "")
    private lazy var calendarButton = createCalendarButton(selector: #selector(calendarButtonTapped))
    private lazy var filterRoverButton = createFilterButton(title: "Curiosity",
                                                            icon: #imageLiteral(resourceName: "Rover.png"),
                                                            selector: #selector(filterRoverButtonTapped))
    
    private lazy var filterCameraButton = createFilterButton(title: "All", 
                                                             icon: #imageLiteral(resourceName: "Camera.png"),
                                                             selector: #selector(filterCameraButtonTapped))
    
    private lazy var saveFilterButton = createSaveFilterButton(icon: #imageLiteral(resourceName: "Add.png"),
                                                               selector: #selector(saveFilterButtonTapped))
    
    private lazy var historyButton = createHistoryButton(selector: #selector(historyButtonTapped))
    
    // Preloader View
    private var preloaderView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "loader")
        animationView.loopMode = .loop
        return animationView
    }()
    
    // MARK: - Lifecycle
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

        showPreloader()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    
    // MARK: - Buttons
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
        AlertManager.showAlert(on: self, ofType: .saveFilter(completion: {[weak self] in
            self?.viewModel.saveFilter()
        }))
    }
    
    @objc private func historyButtonTapped() {
        let vc = HistoryViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extensions
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
            make.top.equalToSuperview().offset(view.frame.height * 0.07)
            make.left.equalToSuperview().offset(view.frame.width * 0.05)
        }
        
        dateLable.snp.makeConstraints { make in
            make.top.equalTo(marsCameraTitle.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(view.frame.width * 0.05)
        }
        
        calendarButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.frame.height * 0.1)
            make.right.equalToSuperview().offset(-view.frame.width * 0.05)
        }
        
        hStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(view.frame.width * 0.05)
            make.right.equalToSuperview().inset(view.frame.width * 0.05)
            make.top.equalTo(dateLable.snp.bottom).offset(view.frame.height * 0.03)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.frame.height * 0.24)
            make.left.right.bottom.equalToSuperview()
        }
        
        historyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(view.frame.width * 0.05)
            make.bottom.equalToSuperview().inset(view.frame.height * 0.03)
            make.height.width.equalTo(view.frame.width * 0.18)
        }
    }
}

// MARK: - TableView Extensions
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        var photo: RoverPhotoProtocol
        if viewModel.currentDate == nil {
            photo = self.viewModel.rovers[indexPath.row]
        } else {
            photo = self.viewModel.roversPhoto[indexPath.row]
        }
            
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

// MARK: - Filters Delegates
extension MainViewController: RoverBottomSheetDelegate {
    func didSelectRover(_ rover: String) {
        self.filterRoverButton.setTitle(rover, for: .normal)
        self.viewModel.selectedRover = rover
        showPreloader()
        
        self.viewModel.fetch { [weak self] in
            self?.showPreloader()
        }
    }
}

extension MainViewController: CameraBottomSheetDelegate {
    func didSelect(_ camera: String) {
        self.filterCameraButton.setTitle(camera, for: .normal)
        self.viewModel.selectedCamera = camera
        showPreloader()
        self.viewModel.fetch { [weak self] in
            self?.showPreloader()
        }
    }
}

extension MainViewController: DatePickerViewControllerDelegate {
    func dateDidSelected(_ date: Date) {
        self.viewModel.selectedDate = date
    
        let formattedDateForLabel = self.viewModel.formatedDate(date: date)
        self.dateLable.text = formattedDateForLabel
        showPreloader()
        self.viewModel.fetch { [weak self] in
            self?.showPreloader()
        }
    }
}

extension MainViewController: HistoryViewControllerDelegate {
    func applyFilter(rover: String?, camera: String?, date: Date?) {
        self.viewModel.selectedRover = rover
        self.viewModel.selectedCamera = camera
        self.viewModel.selectedDate = date
        
        if let rover {
            self.filterRoverButton.setTitle(rover, for: .normal)
        } else {
            self.filterRoverButton.setTitle("All", for: .normal)
        }
        
        if let camera {
            self.filterCameraButton.setTitle(camera, for: .normal)
        } else {
            self.filterCameraButton.setTitle("All", for: .normal)
        }
        
        if let date {
            let convertDate = date
            self.dateLable.text = viewModel.formatedDate(date: convertDate)
        }
        
        self.viewModel.fetch { [weak self] in
            self?.showPreloader()
        }
    }
    
    
}
//MARK: - Other Extensions
private extension MainViewController {
    func updateDateLabel() {
        if viewModel.currentDate == nil {
            guard let rovers = self.viewModel.rovers.first else { return }
            self.dateLable.text = viewModel.formatedDateString(stringDate: rovers.earthDate)
        } else {
            guard let rovers = viewModel.roversPhoto.first else { return }
            self.dateLable.text = viewModel.formatedDateString(stringDate: rovers.earthDate)
        }
    }
    
    private func setRovers() {
        self.viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateDateLabel()
                self?.hidePreloader()
                self?.checkAvailableDataForRover()
            }
        }
    }
    
    
    
    // MARK: - Preloader Methods
    private func showPreloader() {
        self.view.addSubview(preloaderView)
        preloaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        preloaderView.play()
    }
    
    private func hidePreloader() {
        preloaderView.stop()
        preloaderView.removeFromSuperview()
    }
    
    //MARK: Alerts
    private func checkAvailableDataForRover() {
        if viewModel.rovers.isEmpty && viewModel.roversPhoto.isEmpty {
            AlertManager.showAlert(on: self, ofType: .noData)
        }
    }
    
}

