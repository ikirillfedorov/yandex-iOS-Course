//
//  ImagesViewController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 16/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var imagesScrollView: UIScrollView!
    
    var selectedImage = UIImage()
    
    var images = [UIImage?]()
    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesScrollView.isPagingEnabled = true
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imagesScrollView.addSubview(imageView)
            if image == selectedImage {
                imageViews.insert(imageView, at: 0)
            } else {
                imageViews.append(imageView)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = imagesScrollView.frame.size
            imageView.frame.origin.x = imagesScrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        let contentWidth = imagesScrollView.frame.width * CGFloat(imageViews.count)
        imagesScrollView.contentSize = CGSize(width: contentWidth,
                                              height: imagesScrollView.frame.height)
    }
}
