import Foundation

final class DetailViewModel {
    
    let latestPhoto: RoverPhotoProtocol
    
    init(_ latestPhoto: RoverPhotoProtocol) {
        self.latestPhoto = latestPhoto
    }
}
