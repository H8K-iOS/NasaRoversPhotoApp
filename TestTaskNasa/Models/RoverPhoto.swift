import Foundation

struct RoverPhotoResponse: Decodable {
    let photos: [Photo]
}

struct Photo: Decodable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrcPhoto: String
    let earthDatePhoto: String
    let rover: Rover
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case camera
        case imgSrcPhoto = "img_src"
        case earthDatePhoto = "earth_date"
        case rover
    }
}

struct CameraPhoto: Decodable {
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

struct RoverPhoto: Decodable {
    let id: Int
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let cameras: [CameraName]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case cameras
        
    }
}

struct CameraName: Decodable {
    let name: String
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
    }
}
