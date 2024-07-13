import Foundation

struct RoverPhotoResponse: Decodable {
    let photos: [Photo]
}

struct Photo: Decodable {
    let id: Int
    let sol: Int
    let camera: CameraPhoto
    let img_src: String
    let earth_date: String
    let rover: RoverPhoto
}

struct CameraPhoto: Decodable {
    let id: Int
    let name: String
    let rover_id: Int
    let full_name: String
}

struct RoverPhoto: Decodable {
    let id: Int
    let name: String
    let landing_date: String
    let launch_date: String
    let status: String
    let max_sol: Int
    let max_date: String
    let total_photos: Int
    let cameras: [CameraName]
}

struct CameraName: Decodable {
    let name: String
    let full_name: String
}
