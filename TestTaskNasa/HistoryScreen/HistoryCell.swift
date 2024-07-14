import UIKit
import SnapKit

final class HistoryCell: UITableViewCell {
    //MARK: Constants
    public static let identifier = "HistoryCell"
    private let cardContainer = UIView()
    private let roverNameLabel = UILabel()
    private let cameraNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let filtersTile = UILabel()
    private let filtersVStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .vertical
        vs.backgroundColor = .clear
        vs.distribution = .equalSpacing
        vs.spacing = 0
        return vs
    }()
    private(set) var filter: FilterModel?
    //MARK: Variables
    private var lineToFilter: CAShapeLayer?
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainer()
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Methods
    public func configure(with filter: FilterModel) {
        self.filter = filter
        self.roverNameLabel.attributedText = String.labelColor(title: "Rover: ", value: filter.roverName ?? "-")
        self.cameraNameLabel.attributedText = String.labelColor(title: "Camera: ", value: filter.roverCamera ?? "-")
        self.dateLabel.attributedText = String.labelColor(title: "Date: ", value: filter.date ?? "-")
    }
    
}

//MARK: - Extensions
private extension HistoryCell {
    func setupContainer() {
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
    
    func setupUI() {
        self.cardContainer.addSubview(filtersTile)
        self.cardContainer.addSubview(filtersVStack)
        filtersVStack.addArrangedSubview(roverNameLabel)
        filtersVStack.addArrangedSubview(cameraNameLabel)
        filtersVStack.addArrangedSubview(dateLabel)
        
        filtersTile.text = "Filters"
        filtersTile.font = .systemFont(ofSize: 22, weight: .heavy)
        filtersTile.textColor = AccentColors.accentOne.OWColor
        
        roverNameLabel.font = .systemFont(ofSize: 16)
        roverNameLabel.text = "Rover:  Curiosity"
        
        cameraNameLabel.font = .systemFont(ofSize: 16)
        cameraNameLabel.text = "Camera:  Front Hazard Avoidance Camera"
        
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.text = "Date:  June 6, 2019"
        
        filtersVStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        filtersTile.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(16)
        }
        

    }
}

//MARK: - Line setup
extension HistoryCell {
    func createLinePath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.cardContainer.frame.minX, y: self.filtersTile.frame.midY))
        path.addLine(to: CGPoint(x: self.cardContainer.frame.maxX/1.45, y: self.filtersTile.frame.midY))
        return path.cgPath
    }
    
    func configLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = createLinePath()
        layer.strokeColor = AccentColors.accentOne.OWColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1
        return layer
    }
    
    func setupLine() {
        let line = configLayer()
        self.cardContainer.layer.addSublayer(line)
        self.lineToFilter = line
    }
}
