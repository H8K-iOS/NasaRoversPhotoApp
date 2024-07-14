import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    //MARK: Constants
    private let viewModel: DetailViewModel
    private let marsImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: Variables
    private lazy var backBarButton = createBackBarButton(selector: #selector(backBarButtonTapped))
    private var image: UIImage? {
        didSet {
            marsImageView.image = image
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    //MARK: Lifecycle
    init(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LayerColors.layerOne.OWColor
        setupActivityIndicator()
        
        setupUI()
        display()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinited")
    }
    
    //MARK: Methods
    @objc private func backBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Extensions
private extension DetailViewController {
    func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func setupUI() {
        self.navigationItem.leftBarButtonItem = backBarButton
        self.view.addSubview(marsImageView)
        marsImageView.backgroundColor = .clear
        
        marsImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(marsImageView.snp.width)
        }
    }
    
    private func display() {
        guard let imageUrl = URL(string: self.viewModel.latestPhoto.imgSrc.replacingOccurrences(of: "http://", with: "https://")) else {
            return
        }
        self.marsImageView.sd_setImage(with: imageUrl)
    }
}
