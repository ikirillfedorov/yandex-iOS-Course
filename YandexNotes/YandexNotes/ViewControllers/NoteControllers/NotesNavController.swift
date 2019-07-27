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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        notebook.loadFromFile()

        let loadNotesDBOperation = LoadNotesDBOperation(notebook: notebook)
        let queue = OperationQueue()
        queue.addOperation(loadNotesDBOperation)
        
//        notebook.createTestNotes() // create test notes
    }
}
