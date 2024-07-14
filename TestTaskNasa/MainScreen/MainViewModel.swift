import Foundation

final class MainViewModel {
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
    var currentDate: String?
    
    init() {
        fetchRoversForName(roverName: "Curiosity")
    }
    
    //MARK: - Methods
    func numbersOfRows() -> Int {
        return currentDate == nil ? rovers.count : roversPhoto.count
    }
    
    //MARK: - Without Date
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
    
    //MARK: - With Date
    func fetchForDate(date: String) {
        APIService.shared.fetchForDate(date: date) { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.roversPhoto = rovers
                self?.currentDate = date
                print("Fetched \(rovers.count) rovers for date \(date)") // Отладочный вывод
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
