//
//  ColorPickerViewController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 17/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate {
    func chosenColor(color: UIColor)
}

class ColorPickerViewController: UIViewController {
    
    var delegate: ColorPickerDelegate?

    @IBOutlet weak var colorPicker: ColorPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        colorPicker.delegate = self
    }
}

extension ColorPickerViewController: chosenColorDelegate {
    func changeColor(color: UIColor) {
        delegate?.chosenColor(color: color)
    }
    
    func doneButtonTapped(sender: UIButton) {
        guard let controller = navigationController as? NotesNavController else { return }
        controller.colorFromColorPicker = colorPicker.chosenColorView.backgroundColor
        controller.popViewController(animated: true)
    }
}




