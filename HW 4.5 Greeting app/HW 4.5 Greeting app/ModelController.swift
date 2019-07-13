//
//  ModelController.swift
//  HW 4.5 Greeting app
//
//  Created by Kirill Fedorov on 13/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class ModelController: NSObject {

    struct UserInfo {
        var name: String?
    }
    
    var userInfo = UserInfo()
}

extension ModelController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userInfo.name = textField.text!
        textField.resignFirstResponder()
        return true
    }
}
