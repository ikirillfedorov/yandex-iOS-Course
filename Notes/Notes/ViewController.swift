//
//  ViewController.swift
//  Notes
//
//  Created by Kirill Fedorov on 24/06/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var colorViews: [CheckMarkView]!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var colorPickerView: ColorPickerView!
    
    //MARK: - IB Actions
    @IBAction func palleteViewLongPress(_ sender: UILongPressGestureRecognizer) {
        colorPickerView.isHidden = false
        
    }
    
    @IBAction func datePiackerSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            datePicker.isHidden = false
            topConstrain.constant += datePicker.frame.height
            bottomConstrain.constant -= datePicker.frame.height
        } else {
            datePicker.isHidden = true
            topConstrain.constant -= datePicker.frame.height
            bottomConstrain.constant += datePicker.frame.height
        }
    }
    
    @IBAction func tappedToMainScrollView(_ sender: UITapGestureRecognizer) {
        self.contentTextView.resignFirstResponder() //turn off keyboard from contentTextView
        let point = sender.location(in: self.view)
        guard let tappedView = self.view.hitTest(point, with: nil) else { return }
        
        if tappedView is CheckMarkView {
            for view in colorViews {
                view.isHasCheckMark = view === tappedView
                view.setNeedsDisplay()
            }
        }
    }
    
    //MARK: - Supported functions
    func setting() {
        colorViews[0].isHasCheckMark = true //default check mark
        guard let image = UIImage(named: "pallete.jpeg") else { return } //get pallette image
        colorViews[3].backgroundColor = UIColor.init(patternImage: image) //set color for multiColor cell
        for view in colorViews {
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 1
        }
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        colorPickerView.delegate = self
        setting()
    }
}

//MARK - extnsions
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

extension ViewController: chosenColorDelegate {
    func changeColor(color: UIColor) {
        colorViews[3].backgroundColor = color
        for view in colorViews {
            view.isHasCheckMark = view === colorViews[3]
            view.setNeedsDisplay()
        }
    }
}
