//
//  LoadNotesOperation.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 24/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

class LoadNoteOperation: AsyncOperation {
    
    private let notebook: FileNotebook
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation?
    
    private(set) var loadFromBackendResult: [String: Note]?
    private(set) var loadNotesOperationResult = [String: Note]()

    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        self.notebook = notebook
        
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        super.init()
        
        let loadFromBackend = LoadNotesBackendOperation(notebook: notebook)
        self.loadFromBackend = loadFromBackend
        
        self.addDependency(loadFromDb)
        self.addDependency(loadFromBackend)

        dbQueue.addOperation(loadFromDb)
        backendQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        switch loadFromBackend!.result! { // получаем данные с сервера
        case .success(let notes):
            print("success")
            loadFromBackendResult = notes // если данные получили считаем их истиной и записываем
        case .failure(let networkError):
            print(networkError)
            loadFromBackendResult = loadFromDb.result // если данные не получили грузим данные с БД
        }
    }
    
}
