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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var colorPickerView: ColorPickerView!
    
    //MARK: - IB Outlets constrains
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    //MARK: - IB Actions
    @IBAction func palleteViewLongPress(_ sender: UILongPressGestureRecognizer) {
        colorPickerView.isHidden = false
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
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
    private func setting() {
        setBackGroundImage()
        colorViews[0].isHasCheckMark = true //default check mark
        for view in colorViews {
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 1
        }
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
    }
    
    @objc private func updateTextViw(parametrs: NSNotification) {
        guard let userInfo = parametrs.userInfo,
         let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if parametrs.name == UIResponder.keyboardWillHideNotification {
            scrollViewBottomConstraint.constant = 0.0
        } else {
            scrollViewBottomConstraint.constant = -keyboardFrame.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        colorPickerView.delegate = self
        //MARK: - keyboard hitifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViw), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViw), name: UIResponder.keyboardWillHideNotification, object: nil)

        setting()
    }
    
    private func setBackGroundImage() {
        let view = colorViews[3]
        guard let image = UIImage(named: "pallete.jpeg") else { return } //get pallette image
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor.init(patternImage: newImage)
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

