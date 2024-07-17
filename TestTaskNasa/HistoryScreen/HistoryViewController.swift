import UIKit
protocol HistoryViewControllerDelegate: AnyObject {
    func applyFilter(rover: String?, camera: String?, date: Date?)
}

final class HistoryViewController: UIViewController {
    //MARK: Constants
    private let viewModel: HistoryViewModel
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = BackgroundColor.backgroundOne.OWcolor
        tv.separatorStyle = .none
        tv.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        return tv
    }()
    private let noHistoryImageView = UIImageView()
    
  
    
    //MARK: Variables
    private lazy var backButton = createBackBarButton(selector: #selector(backButtonTapped))
    private lazy var titleLable = createLabel(font: 34, weight: .bold, text: "History")
    
    weak var delegate: HistoryViewControllerDelegate?
    
    //MARK: Lifecycle
    init(viewModel: HistoryViewModel = HistoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = true
        self.view.backgroundColor = AccentColors.accentOne.OWColor
        
        setupUI()
        setupLayouts()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setHistory()
        checkDataConsist()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    
    @objc private func backButtonTapped() {
        self.navigationController!.popViewController(animated: true)
    }
}

//MARK: - Extensions
private extension HistoryViewController {
    func setupUI() {
        self.view.addSubview(tableView)
        self.view.addSubview(backButton)
        self.view.addSubview(titleLable)
        self.view.addSubview(noHistoryImageView)
    }
    
    func showEmptyHistoryImage() {
        noHistoryImageView.image = #imageLiteral(resourceName: "Empty.png")
        //noHistoryImageView.tintColor = .gray
        noHistoryImageView.isHidden = false
        noHistoryImageView.snp.makeConstraints { make in
            make.centerX.equalTo(tableView.snp.centerX)
            make.centerY.equalTo(tableView.snp.centerY)
            make.width.equalTo(193)
            make.height.equalTo(186)
        }
    }
    
    func setupLayouts() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.left.equalToSuperview().offset(20)
        }
        
        titleLable.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(135)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}

//MARK: - Table View Extensions
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = self.viewModel.history[indexPath.row]
        AlertManager.showAlert(on: self, ofType: .applyFilter(useHandler: {
            self.delegate?.applyFilter(rover: filter.roverName, camera: filter.roverCamera, date: filter.date)
            self.navigationController!.popViewController(animated: true)
        }, deleteHandler: { [weak self] in
            self?.viewModel.deleteFilter(filter: filter, completion: { [weak self] in
                guard let self = self else { return }
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                self.checkDataConsist()
            })
        }))
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.historyCount)
        return self.viewModel.historyCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.selectedBackgroundView = .none
        cell.configure(with: self.viewModel.history[indexPath.row])
        return cell
    }
}

extension HistoryViewController {
    func setHistory() {
        self.viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.checkDataConsist()
        }
    }
    
    func checkDataConsist() {
        if self.viewModel.history.isEmpty {
            showEmptyHistoryImage()
        } else {
            self.noHistoryImageView.isHidden = true
        }
    }
}
