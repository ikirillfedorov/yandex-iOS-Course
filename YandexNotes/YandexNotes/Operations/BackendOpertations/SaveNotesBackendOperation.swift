import Foundation

enum NetworkError {
    case unreachable
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    init(notes: [String: Note]) {
        super.init()
    }
    
    override func main() {
        print("BACKEND START")
        result = .failure(.unreachable)
        print("BACKEND NOTE ADDED")
        print("BACKEND FINISH")
        finish()
    }
}
