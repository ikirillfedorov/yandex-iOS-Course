//
//  LoadNotesDBOperation.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 24/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation


class LoadNotesDBOperation: BaseDBOperation {
    
    private(set) var result = [String: Note]()
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        let tempNotebook = FileNotebook()
        tempNotebook.loadFromFile()
        result = tempNotebook.notes
        finish()
    }
}
