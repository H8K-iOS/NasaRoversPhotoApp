import Foundation

struct RoverResponse: Decodable {
    let latestPhotos: [LatestPhoto]
    
    enum CodingKeys: String, CodingKey {
        case latestPhotos = "latest_photos"
    }
}

struct LatestPhoto: Decodable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

struct Camera: Decodable {
    let id: Int
    let name: String
    let roverId: Int
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverId = "rover_id"
        case fullName = "full_name"
    }
}

struct Rover: Decodable {
    let id: Int
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
    }
}
