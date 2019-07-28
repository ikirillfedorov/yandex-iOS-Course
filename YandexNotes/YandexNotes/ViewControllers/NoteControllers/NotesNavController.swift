//
//  NotesNavController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 14/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class NotesNavController: UINavigationController {
    
    var notebook = FileNotebook()
    var colorFromColorPicker: UIColor?
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    
    let loadNoteQueue = OperationQueue()
    let removeNoteOueue = OperationQueue()
    let saveNotesQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNoteQueue.addOperation(LoadNoteOperation(notebook: notebook, backendQueue: backendQueue, dbQueue: dbQueue))
        
        
//        notebook.createTestNotes() // create test notes
    }
}
