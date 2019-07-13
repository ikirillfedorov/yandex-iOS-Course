//
//  LoginViewController.swift
//  HW 4.5 Greeting app
//
//  Created by Kirill Fedorov on 13/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    


    @IBOutlet weak var nameTextField: UITextField!
    
    var modelController: ModelController!

    
    @IBAction func logInButtonAction(_ sender: UIButton) {
        
        let name = nameTextField.text
        modelController.userInfo.name = name
        
        let infoViewController = InfoViewController()
        infoViewController.modelController = modelController
        
        let editViewController = EditViewController()
        editViewController.modelController = modelController

        let tabBarController = UITabBarController()
        
        infoViewController.tabBarItem = UITabBarItem(title: "Hello", image: UIImage(named: "Star.png"), selectedImage: nil)
        editViewController.tabBarItem = UITabBarItem(title: "Edit", image: UIImage(named: "Star.png"), selectedImage: nil)

        tabBarController.viewControllers = [infoViewController, editViewController]
        
        self.present(tabBarController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        nameTextField.delegate = self
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
