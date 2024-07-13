import Foundation
import UIKit

enum Endpoint {
    case fetchForRoverName(roverName: String)
    case fetchForCameraType(cameraType: String)
    case fetchForRoverAndCamera(roverName: String, cameraType: String)
    
    case fetchForDate(date: String)
    case fetchForRoverAndDate(roverName: String, date: String)
    case fetchForCameraAndDate(cameraType: String, date: String)
    
    case fetchForAllFilters(roverName: String, cameraType: String, date: String)
    
    var request: URLRequest? {
        guard let url = self.url else { return nil}
        var req = URLRequest(url: url)
        req.httpMethod = self.httpMethods
        req.httpBody = nil
        return req
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseUrl
        components.port = Constants.port
        components.path = self.path
        components.queryItems = query
        return components.url
    }
    
    var path: String {
        switch self {
        case .fetchForRoverName(let roverName):
            return "/mars-photos/api/v1/rovers/\(roverName)/latest_photos"
            
        case .fetchForCameraType(_):
            return "/mars-photos/api/v1/rovers/curiosity/latest_photos"
            
        case .fetchForRoverAndCamera(let roverName, _):
            return "/mars-photos/api/v1/rovers/\(roverName)/latest_photos"
            
        case .fetchForDate:
            return "/mars-photos/api/v1/rovers/curiosity/photos"
            
        case .fetchForAllFilters(roverName: let roverName, cameraType: _, date: _):
            return "/mars-photos/api/v1/rovers/\(roverName)/photos"
            
        
        case .fetchForRoverAndDate(roverName: let roverName, date: let date):
            return "/mars-photos/api/v1/rovers/\(roverName)/photos"
            
        case .fetchForCameraAndDate(cameraType: let cameraType, date: let date):
            return "/mars-photos/api/v1/rovers/curiosity/photos"
        }
    }
    
    var httpMethods: String {
        HTTP.Methods.get.rawValue
    }
    
    var query: [URLQueryItem]? {
        var items = [URLQueryItem(name: "api_key", value: Constants.apiKey)]
        switch self {
            
        case .fetchForRoverName(roverName: _):
            break
            
        case .fetchForCameraType(cameraType: let cameraType):
            items.append(URLQueryItem(name: "camera", value: cameraType))
            
        case .fetchForDate(date: let date):
            items.append(URLQueryItem(name: "earth_date", value: date))
            
        case .fetchForRoverAndCamera(roverName: _, cameraType: let cameraType):
            items.append(URLQueryItem(name: "camera", value: cameraType))
            
        case .fetchForAllFilters(roverName: _, cameraType: let cameraType, date: let date):
            items.append(contentsOf: [URLQueryItem(name: "camera", value: cameraType),
                                      URLQueryItem(name: "earth_date", value: date)
                                     ])
            
            
            return items
        case .fetchForRoverAndDate(roverName: _, date: let date):
            items.append(URLQueryItem(name: "earth_date", value: date))
            
            
            return items
        case .fetchForCameraAndDate(cameraType: let cameraType, date: let date):
            items.append(contentsOf: [URLQueryItem(name: "camera", value: cameraType),
                                      URLQueryItem(name: "earth_date", value: date)
                                     ])
        }
        return items
    }
}

