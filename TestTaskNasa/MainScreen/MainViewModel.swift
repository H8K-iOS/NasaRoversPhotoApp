import Foundation

final class MainViewModel {
    private(set) var rovers: [LatestPhoto] = [] {
        didSet {
            self.onUpdate?()
        }
    }
    
    var onUpdate: (() -> Void)?
    
    init() {
        fetchRoversForName(roverName: "Curiosity")
    }
    
    //MARK: - Methods
    func fetchRoversForName(roverName: String) {
        APIService.shared.fetchForRover(roverName: roverName) { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
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
            case .failure(let error):
                print("Error fetching rovers:", error)
            }
        }
    }
    
    func fetchForData(date: String) {
        
    }
    
    func fetchRoverForNameAndCamera(roverName: String, cameraType: String) {
        APIService.shared.fetchForRoverAndCamera(rover: roverName, camera: cameraType) { [weak self] result in
            switch result {
                
            case .success(let rovers):
                self?.rovers = rovers
                print("DEBUG PRINT:", "\(rovers.count) rovers fetched")
            case .failure(let error):
                print("Error fetching rovers:", error)
            }
        }
    }
    
    func fetchRoverForAllfilters(roverName: String, cameraType: String, date: Date) {
        APIService.shared.fetchForAllFilters(roverName: roverName,
                                             cameraType: cameraType,
                                             date: date) { [weak self] result in
            switch result {
                
            case .success(let rovers):
                self?.rovers = rovers
            case .failure(let error):
                print("Error fetching rovers:", error)
            }
        }
    }
    
    func numbersOfRows() -> Int {
        self.rovers.count
    }
    
}
