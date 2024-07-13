import Foundation
import UIKit

enum APIServiceError: Error {
    case serverError(String)
    case decodingError(String)
    case invalidResponse
}

final class APIService {
    static let shared = APIService()
    
    private func perfomRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping(Result<T, APIServiceError>) -> Void) {
        guard let request = endpoint.request else {
            completion(.failure(.invalidResponse))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.invalidResponse))
            }
            
            guard let responseHTTP = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else  {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let roverResponse = try decoder.decode(RoverResponse.self, from: data)
                completion(.success(roverResponse.latestPhotos as! T))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
    
    //MARK: - For Rover
    public func fetchForRover(roverName: String, completion: @escaping(Result<[LatestPhoto], APIServiceError>)-> Void) {
        perfomRequest(endpoint: .fetchForRoverName(roverName: roverName), completion: completion)
    }
    
    public func fetchAllRovers(completion: @escaping (Result<[LatestPhoto], APIServiceError>) -> Void) {
        perfomRequest(endpoint: .fetchAllRovers, completion: completion)
    }
    
    //MARK: - For Camera
    public func fetchForCamera(cameraName: String, completion: @escaping(Result<[LatestPhoto], APIServiceError>) -> Void) {
        perfomRequest(endpoint: .fetchForCameraType(cameraType: cameraName), completion: completion)
    }
    
    //MARK: - For Date
    public func fetchForDate(date: Date, completion: @escaping(Result<[LatestPhoto], APIServiceError>) -> Void) {
        perfomRequest(endpoint: .fetchForDate(date: date), completion: completion)
    }
    
    //MARK: - For Rover And Camera
    public func fetchForRoverAndCamera(rover roverName: String, camera cameraType: String, completion: @escaping (Result<[LatestPhoto], APIServiceError>) -> Void) {
        perfomRequest(endpoint: .fetchForRoverAndCamera(roverName: roverName, cameraType: cameraType), completion: completion)
    }
    
    //MARK: - For All Filters
    public func fetchForAllFilters(roverName: String, cameraType: String, date: Date, completion: @escaping(Result<[LatestPhoto], APIServiceError>) -> Void) {
        perfomRequest(endpoint: .fetchForAllFilters(roverName: roverName, cameraType: cameraType, date: date), completion: completion)
    }
}

