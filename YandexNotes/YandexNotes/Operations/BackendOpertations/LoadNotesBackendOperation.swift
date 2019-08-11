//
//  LoadNotesBackendOperation.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 24/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation


enum LoadNotesBackendResult {
    case success([String: Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var notebook: FileNotebook
    var result: LoadNotesBackendResult?
    let backendNotes = BackendNotes()
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
    
    override func main() {
        backendNotes.getGistContent {
            switch self.backendNotes.result {
            case .success:
                self.result = .success(self.backendNotes.notes)
            case .failure:
                self.result = .failure(.error)
            }
            self.finish()
        }
    }
}
