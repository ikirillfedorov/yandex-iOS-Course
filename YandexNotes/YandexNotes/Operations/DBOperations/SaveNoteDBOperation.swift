import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    
    init(note: Note, notebook: FileNotebook) {
        self.note = note
        print("Before notes count = \(notebook.notes.count)")
        super.init(notebook: notebook)
        print("After notes count = \(notebook.notes.count)")

    }
    
    override func main() {
        print("DB START")
        notebook.add(note)
        notebook.saveToFile()
        print("DB NOTE ADDED")
        print("DB FINISH")
        finish()
    }
}


