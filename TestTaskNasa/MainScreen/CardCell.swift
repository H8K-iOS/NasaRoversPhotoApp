import UIKit
import SnapKit
import SDWebImage

final class CardCell: UITableViewCell {
    // MARK: - Constants
    public static let identifier = "CardCell"
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let cardContainer = UIView()
    private let roverLabel = UILabel()
    private let cameraTypeLabel = UILabel()
    private let dateLabel = UILabel()
    private let marsImageView = UIImageView()
    private let vStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .vertical
        vs.backgroundColor = .clear
        vs.distribution = .equalSpacing
        vs.spacing = 0
        return vs
    }()
    private let dateFormater: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM d, yyyy"
        return df
    }()

    
    // MARK: - Variables
    private(set) var rovers: LatestPhoto!
    private var image: UIImage? {
        didSet {
            marsImageView.image = image
            updateActivityIndicatorVisibility()
        }
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setContainer()
        setupUI()
        setupLayouts()
        setupIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    public func config(with rovers: RoverPhotoProtocol) {
        roverLabel.attributedText = String.labelColor(title: "Rover: ", value: rovers.roverName)
        cameraTypeLabel.attributedText = String.labelColor(title: "Camera: ", value: rovers.cameraFullName)
        
        let formatedDate = dateFormater.date(from: rovers.earthDate)
        let date = dateFormater.string(from: formatedDate ?? Date())
        
        dateLabel.attributedText = String.labelColor(title: "Date: ", value: date)
        guard let imageUrl = URL(string: rovers.imgSrc.replacingOccurrences(of: "http://", with: "https://")) else {
            print("Invalid URL string: \(rovers.imgSrc)")
            return
        }
        
        marsImageView.image = nil
        updateActivityIndicatorVisibility()
        
        self.marsImageView.sd_setImage(with: imageUrl) {[weak self] image, _, _, _ in
            self?.image = image
        }
        
    }
    
    private func setContainer() {
        self.backgroundColor = .clear
        
        self.contentView.addSubview(cardContainer)
       
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 30
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.2
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainer.layer.shadowRadius = 4
        
        cardContainer.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).inset(10)
        }
    }

    private func setupIndicator() {
        self.cardContainer.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(marsImageView.snp.center)
        }
    }
    
    private func setupUI() {
        self.cardContainer.addSubview(vStack)
        vStack.addArrangedSubview(roverLabel)
        vStack.addArrangedSubview(cameraTypeLabel)
        vStack.addArrangedSubview(dateLabel)
        
        self.cardContainer.addSubview(marsImageView)
    
        roverLabel.font = .systemFont(ofSize: 16)
        
        cameraTypeLabel.font = .systemFont(ofSize: 16)
        cameraTypeLabel.numberOfLines = 2

        dateLabel.font = .systemFont(ofSize: 16)
        
        marsImageView.backgroundColor = .gray.withAlphaComponent(0.1)
        marsImageView.layer.cornerRadius = 30
        marsImageView.clipsToBounds = true
    }
    
    private func setupLayouts() {
        marsImageView.snp.makeConstraints { make in
            make.top.equalTo(cardContainer).offset(10)
            make.bottom.right.equalTo(cardContainer).inset(10)
            make.width.height.equalTo(130)
        }
        
        vStack.snp.makeConstraints { make in
            make.top.equalTo(cardContainer).offset(26)
            make.left.equalTo(cardContainer).offset(16)
            make.right.equalTo(marsImageView.snp.left).inset(-10)
            make.bottom.equalTo(cardContainer).inset(27)
        }
    }

    private func updateActivityIndicatorVisibility() {
        if marsImageView.image == nil {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
}
