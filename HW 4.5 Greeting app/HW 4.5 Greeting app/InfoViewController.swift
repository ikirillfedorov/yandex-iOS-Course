//
//  InfoViewController.swift
//  HW 4.5 Greeting app
//
//  Created by Kirill Fedorov on 13/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var modelController: ModelController!
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userInfo = modelController.userInfo
        helloLabel.text = "Hello," + " " + (userInfo.name ?? "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = modelController.userInfo
        helloLabel.text = userInfo.name
    }
}
