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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newNameTextField.delegate = modelController
    }
}


