protocol RoverPhotoProtocol {
    var roverName: String { get }
    var cameraFullName: String { get }
    var earthDate: String { get }
    var imgSrc: String { get }
}

extension LatestPhoto: RoverPhotoProtocol {
    var roverName: String {
        return rover.name
    }
    
    var cameraFullName: String {
        return camera.fullName
    }
}

extension Photo: RoverPhotoProtocol {
    var roverName: String {
        return rover.name
    }
    
    var cameraFullName: String {
        return camera.fullName
    }
    
    var earthDate: String {
        return self.earthDatePhoto
    }
    
    var imgSrc: String {
        return self.imgSrcPhoto
    }
}
