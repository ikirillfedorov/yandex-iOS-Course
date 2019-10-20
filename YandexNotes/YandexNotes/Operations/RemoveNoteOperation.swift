//
//  RemoveNoteOperation.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 24/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

// нужно сделать SaveNotesBackendOperation и RemoveNoteDBOperation
// типо удаляет и базы данных и сохраняет на сервере

// Операция удаления заметки RemoveNoteOperation.
// Должна вызывать SaveNotesBackendOperation и RemoveNoteDBOperation. Должна вызываться из UI по событию удаления заметки.

class RemoveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let removeDBOperation: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?

    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        removeDBOperation = RemoveNoteDBOperation(note: note, notebook: notebook)
        super.init()
        
        let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        self.saveToBackend = saveToBackend
        
        self.addDependency(saveToBackend)
        saveToBackend.addDependency(removeDBOperation)
        
        dbQueue.addOperation(removeDBOperation)
        backendQueue.addOperation(saveToBackend)
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
