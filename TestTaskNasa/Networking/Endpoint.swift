import Foundation
import UIKit

enum Endpoint {
    case fetchForRoverName(roverName: String)
    case fetchForCameraType(cameraType: String)
    case fetchForDate(date: Date)
    case fetchForRoverAndCamera(roverName: String, cameraType: String)
    case fetchForAllFilters(roverName: String, cameraType: String, date: Date)
    case fetchAllRovers
    
    
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
            return "/mars-photos/api/v1/rovers/photos"
            
        case .fetchForAllFilters(roverName: let roverName, cameraType: _, date: _):
            return "/mars-photos/api/v1/rovers/\(roverName)/photos"
        
        case .fetchAllRovers:
            return "/mars-photos/api/v1/rovers"
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
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFormater.string(from: date)
            items.append(URLQueryItem(name: "date", value: dateStr))
            
        case .fetchForRoverAndCamera(roverName: _, cameraType: let cameraType):
            items.append(URLQueryItem(name: "camera", value: cameraType))
            
        case .fetchForAllFilters(roverName: _, cameraType: let cameraType, date: let date):
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFormater.string(from: date)
            items.append(contentsOf: [URLQueryItem(name: "camera", value: cameraType),
                                      URLQueryItem(name: "earth_date", value: dateStr)
                                     ])
            
        case .fetchAllRovers:
            break
        }
        return items
    }
}


