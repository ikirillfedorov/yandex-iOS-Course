//
//  EditViewController.swift
//  HW 4.5 Greeting app
//
//  Created by Kirill Fedorov on 13/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    var modelController: ModelController!

    @IBOutlet weak var newNameTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newNameTextField.text = modelController.userInfo.name
    }
    
    override func viewDidLoad() {
        newNameTextField.delegate = self
    }
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        modelController.userInfo.name = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
}


