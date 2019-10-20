import Foundation

enum NetworkError: String {
    case unreachable
    case error
    case noData
    case parseError
    case nwErrorOrNotFileExtist
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    var notes = [String: Note]()
    var backend = BackendNotes()
    
    init(notes: [String: Note]) {
        self.notes = notes
        super.init()
    }
    
    override func main() {
        backend.setContentForGist(notes: notes) {
            print(self.backend.notes)
        }

        
        result = .failure(.unreachable)
        finish()
    }
}
