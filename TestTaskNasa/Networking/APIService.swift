import Foundation

enum APIServiceError: Error {
    case serverError(String)
    case decodingError(String)
    case invalidResponse
}

final class APIService {
    static let shared = APIService()
    
    private func performRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard let request = endpoint.request else {
            completion(.failure(.invalidResponse))
            return
        }
        print(request.url ?? "Invalid URL")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let responseHTTP = response as? HTTPURLResponse, responseHTTP.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()

                switch endpoint {
                case .fetchForDate, .fetchForCameraAndDate, .fetchForRoverAndDate, .fetchForAllFilters:
                    let roverPhotoResp = try decoder.decode(RoverPhotoResponse.self, from: data)
                    if let photos = roverPhotoResp.photos as? T {
                        completion(.success(photos))
                    } else {
                        completion(.failure(.decodingError("Failed to cast RoverPhotoResponse.photos to expected type.")))
                    }
                default:
                    let roverResponse = try decoder.decode(RoverResponse.self, from: data)
                    if let latestPhotos = roverResponse.latestPhotos as? T {
                        completion(.success(latestPhotos))
                    } else {
                        completion(.failure(.decodingError("Failed to cast RoverResponse.latestPhotos to expected type.")))
                    }
                }
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Methods
    public func fetchForRover(roverName: String, completion: @escaping (Result<[LatestPhoto], APIServiceError>) -> Void) {
        performRequest(endpoint: .fetchForRoverName(roverName: roverName), completion: completion)
    }
    
    public func fetchForCamera(cameraName: String, completion: @escaping (Result<[LatestPhoto], APIServiceError>) -> Void) {
        performRequest(endpoint: .fetchForCameraType(cameraType: cameraName), completion: completion)
    }
    
    public func fetchForRoverAndCamera(rover roverName: String, camera cameraType: String, completion: @escaping (Result<[LatestPhoto], APIServiceError>) -> Void) {
        performRequest(endpoint: .fetchForRoverAndCamera(roverName: roverName, cameraType: cameraType), completion: completion)
    }
    
    public func fetchForDate(date: String, completion: @escaping (Result<[Photo], APIServiceError>) -> Void) {
        performRequest(endpoint: .fetchForDate(date: date), completion: completion)
    }
    
    public func fetchForCameraAndDate(cameraType: String, date: String, completion: @escaping (Result<[Photo], APIServiceError>) -> Void) {
        performRequest(endpoint: .fetchForCameraAndDate(cameraType: cameraType, date: date), completion: completion)
    }
    
    public func fetchForRoverAndDate(roverName: String, date: String, completion: @escaping (Result<[Photo], APIServiceError>) -> Void) {
        performRequest(endpoint: .fetchForRoverAndDate(roverName: roverName, date: date), completion: completion)
    }
    
    public func fetchForAllFilters(roverName: String, cameraType: String, date: String, completion: @escaping (Result<[Photo], APIServiceError>) -> Void) {
        performRequest(endpoint: .fetchForAllFilters(roverName: roverName, cameraType: cameraType, date: date), completion: completion)
    }
}
