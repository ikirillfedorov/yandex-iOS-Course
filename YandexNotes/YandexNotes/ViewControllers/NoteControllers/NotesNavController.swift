//
//  NotesNavController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 14/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class NotesNavController: UINavigationController {
    var token = ""
    
    var notebook = FileNotebook()
    var colorFromColorPicker: UIColor?
    
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonQueue.addOperation(LoadNoteOperation(notebook: self.notebook, backendQueue: self.backendQueue, dbQueue: self.dbQueue))
        sleep(2)
        OperationQueue.main.waitUntilAllOperationsAreFinished()

        print("viewDidLoad finish")
    }
    
    //MARK: TESTING
    func checkToken() {
        guard !token.isEmpty else {
            print("Token NOT HERE")
            requestToken()
            return
        }
        print("Token HERE")
    }
    
    
    
    private func requestToken() {
        
        let requestTokenViewController = AuthViewController()
        requestTokenViewController.delegate = self
        requestTokenViewController.completion = {
            print("TOKEN CREATED")
//            self.commonQueue.addOperation(LoadNoteOperation(notebook: self.notebook, backendQueue: self.backendQueue, dbQueue: self.dbQueue))
        }
        
        present(requestTokenViewController, animated: false, completion: nil)
    }
}

extension NotesNavController: AuthViewControllerDelegate {
    func handleTokenChanged(token: String) {
        self.token = token
    }
}
