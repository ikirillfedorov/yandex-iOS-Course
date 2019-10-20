//
//  RemoveNoteDBOperation.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 24/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        super.init()
        
        let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        self.saveToBackend = saveToBackend
        self.addDependency(saveToBackend)
        saveToBackend.addDependency(saveToDb)
        backendQueue.addOperation(saveToBackend)
        
        addDependency(saveToDb)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
        switch saveToBackend!.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
