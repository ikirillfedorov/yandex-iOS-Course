//
//  ImagesNavController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 18/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class ImagesNavController: UINavigationController {
    
    var images = [UIImage?]()

    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
        
        self.images = [
            UIImage(named: "image1.jpeg"),
            UIImage(named: "image2.jpeg"),
            UIImage(named: "image3.jpeg"),
            UIImage(named: "image4.jpeg"),
            UIImage(named: "image5.jpeg"),
            UIImage(named: "image6.jpeg"),
            UIImage(named: "image7.jpeg"),
            UIImage(named: "image8.jpeg"),
            UIImage(named: "image9.jpeg"),
            UIImage(named: "image10.jpeg"),
            UIImage(named: "image11.jpeg")
        ]
    }
    
}
