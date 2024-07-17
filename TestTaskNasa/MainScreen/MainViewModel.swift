import Foundation

final class MainViewModel {
    private let dbManager = DBManagerImpl()
    private let dateFormatterManager = DateFormatterManager.shared
    
    private(set) var rovers: [LatestPhoto] = [] {
        didSet {
            self.onUpdate?()
        }
    }
    
    private(set) var roversPhoto: [Photo] = [] {
        didSet {
            self.onUpdate?()
        }
    }
    
    var onUpdate: (() -> Void)?
    
    public var selectedRover: String?
    public var selectedCamera: String?
    public var selectedDate: Date?
    
    var currentDate: String?
    
    init() {
        fetchRoversForName(roverName: "Curiosity")
    }
    
    //MARK: - Methods
    func numbersOfRows() -> Int {
        return currentDate == nil ? rovers.count : roversPhoto.count
    }
    
    func saveFilter() {
        setFilter(rover: selectedRover, camera: selectedCamera, date: selectedDate)
    }
    
    func setFilter(rover: String?, camera: String?, date: Date?) {
        let filter = FilterModel()
        
        filter.roverName = rover
        filter.roverCamera = camera
        filter.date = date
        
        dbManager.saveFilter(filter: filter)
    }
    
    
    func fetch(completion: @escaping()->Void) {
        let roverSelected = selectedRover != nil && !selectedRover!.isEmpty
        let cameraSelected = selectedCamera != nil && !selectedCamera!.isEmpty && !selectedCamera!.isAll
        let dateSelected = selectedDate != nil
        
        if roverSelected && cameraSelected && dateSelected {
            let rover = selectedRover!
            let camera = selectedCamera!
            let date = self.dateFormatterManager.formattedDateForReq(from: selectedDate!)
            self.fetchRoverForAllfilters(roverName: rover, cameraType: camera, date: date)
        } else if roverSelected && cameraSelected {
            let rover = selectedRover!
            let camera = selectedCamera!
            self.fetchRoverForNameAndCamera(roverName: rover, cameraType: camera)
        } else if roverSelected && dateSelected {
            let rover = selectedRover!
            let date = dateFormatterManager.formattedDateForReq(from: selectedDate!)
            self.fetchForRoverAndDate(roverName: rover, date: date)
        } else if cameraSelected && dateSelected {
            let camera = selectedCamera!
            let date = dateFormatterManager.formattedDateForReq(from: selectedDate!)
            self.fetchForCameraAndDate(cameraType: camera, date: date)
        } else if roverSelected {
            let rover = selectedRover!
            self.fetchRoversForName(roverName: rover)
        } else if cameraSelected {
            let camera = selectedCamera!
            self.fetchForCamera(cameraName: camera)
        } else if dateSelected {
            let date = dateFormatterManager.formattedDateForReq(from: selectedDate!)
            self.fetchForDate(date: date)
        } else {
            self.fetchRoversForName(roverName: "Curiosity")
            completion()
        }
    }
    
    //MARK: - Date Formatter Methods
    func formatedDateString(stringDate: String) -> String {
        self.dateFormatterManager.formatDateString(stringDate)
    }
    
    func convertToDate(dateString: String) -> Date? {
        self.dateFormatterManager.convertToDate(dateString: dateString)
    }
    
    func formatedDate(date: Date) -> String {
        self.dateFormatterManager.formattedDateString(from: date)
    }
    
    //MARK: - Network Calls
    //MARK: Without Date
    func fetchRoversForName(roverName: String) {
        APIService.shared.fetchForRover(roverName: roverName) { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
                self?.currentDate = nil
            case .failure(let error):
                print("Error fetching rovers:", error)
            }
        }
    }
    
    func fetchForCamera(cameraName: String) {
        APIService.shared.fetchForCamera(cameraName: cameraName) { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
                self?.currentDate = nil
            case .failure(let error):
                print("Error fetching rovers:", error)
            }
        }
    }
    
   
    
    func fetchRoverForNameAndCamera(roverName: String, cameraType: String) {
        APIService.shared.fetchForRoverAndCamera(rover: roverName, camera: cameraType) { [weak self] result in
            switch result {
                
            case .success(let rovers):
                self?.rovers = rovers
                self?.currentDate = nil
                print("DEBUG PRINT:", "\(rovers.count) rovers fetched")
            case .failure(let error):
                print("Error fetching rovers:", error)
            }
        }
    }
    
    //MARK: With Date
    func fetchForDate(date: String) {
        APIService.shared.fetchForDate(date: date) { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.roversPhoto = rovers
                self?.currentDate = date
                print("Fetched \(rovers.count) rovers for date \(date)")
                self?.onUpdate?()
            case .failure(let error):
                print(error)
            }
        }
    }
        
        func fetchForCameraAndDate(cameraType: String, date: String) {
            APIService.shared.fetchForCameraAndDate(cameraType: cameraType, date: date) { [weak self] result in
                switch result {
                case .success(let rovers):
                    self?.roversPhoto = rovers
                    self?.currentDate = date
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func fetchForRoverAndDate(roverName: String, date: String) {
            APIService.shared.fetchForRoverAndDate(roverName: roverName, date: date) { [weak self] result in
                switch result {
                case .success(let rovers):
                    self?.roversPhoto = rovers
                    self?.currentDate = date
                case .failure(let error):
                    print(error)
                }
            }
        }
    
    func fetchRoverForAllfilters(roverName: String, cameraType: String, date: String) {
        APIService.shared.fetchForAllFilters(roverName: roverName,
                                             cameraType: cameraType,
                                             date: date) { [weak self] result in
            switch result {
                
            case .success(let rovers):
                self?.roversPhoto = rovers
                self?.currentDate = date
            case .failure(let error):
                print("Error fetching rovers:", error)
            }
        }
    }
}
