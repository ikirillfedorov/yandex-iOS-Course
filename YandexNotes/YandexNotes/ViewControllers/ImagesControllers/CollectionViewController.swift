//
//  CollectionViewController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 17/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [UIImage?]()
    
    @IBAction func addImageBarButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add image", message: nil, preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "From Photos", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
//        let actionCamera = UIAlertAction(title: "From Camera", style: .default) { (alert) in
//            self.imagePicker.sourceType = .camera
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(actionPhoto)
//        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navController = navigationController as? ImagesNavController else { return }
        images = navController.images
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        imagePicker.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ImagesViewController, segue.identifier == "ShowDetailScreen" {
            if let image = sender as? UIImage {
                controller.selectedImage = image
                controller.images = images
            }
        }
    }
}

//MARK: - Extensions
extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell {
            itemCell.imageView.image = images[indexPath.row]
            itemCell.backgroundColor = .gray
            itemCell.imageView.contentMode = .scaleToFill
            
            return itemCell
        }
        return UICollectionViewCell()
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.row]
        performSegue(withIdentifier: "ShowDetailScreen", sender: selectedImage)
    }
}

extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/3 - 1, height: collectionViewWidth/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let navController = navigationController as? ImagesNavController else { return }
            navController.images.append(pickedImage)
        }
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}
