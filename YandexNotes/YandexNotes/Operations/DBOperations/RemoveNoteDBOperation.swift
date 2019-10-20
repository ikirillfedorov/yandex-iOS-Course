//
//  RemoveNoteDBOperation.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 24/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    
    init(note: Note, notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        notebook.saveToFile()
        finish()
    }
}

