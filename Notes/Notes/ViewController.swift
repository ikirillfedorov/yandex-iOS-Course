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
    
    @IBOutlet weak var chosenColorView: UIView!
    @IBOutlet weak var chosenColorHexLabel: UILabel!
    @IBOutlet weak var colorPickerMainView: UIView!
    @IBOutlet weak var palleteView: HSBColorPicker!
    
    
    //MARK: - IB Actions
    @IBAction func palleteViewLongPress(_ sender: UILongPressGestureRecognizer) {
        colorPickerMainView.isHidden = false
    }
    @IBAction func colorPickerDoneButton(_ sender: UIButton) {
        colorPickerMainView.isHidden = true
        colorViews[3].backgroundColor = chosenColorView.backgroundColor
        for view in colorViews {
            view.isHasCheckMark = view == colorViews[3]
            view.setNeedsDisplay()
        }
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
                view.isHasCheckMark = view == tappedView
                view.setNeedsDisplay()
            }
        }
    }

    //MARK: - Supported functions
        func getStringFrom(color: UIColor) -> String {
        guard let components = color.cgColor.components else { return ""}
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String.init(format: "%02X%02X%02X", arguments: [Int(r * 255), Int(g * 255), Int(b * 255)])
    }

    func setting() {
        colorViews[0].isHasCheckMark = true //default check mark
        guard let image = UIImage(named: "pallete.jpeg") else { return } //get pallette image
        colorViews[3].backgroundColor = UIColor.init(patternImage: image) //set color for multiColor cell
        for view in colorViews {
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 2
        }
        contentTextView.layer.borderColor = UIColor.gray.cgColor
        contentTextView.layer.borderWidth = 1
        
        palleteView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.cgColor
        
        chosenColorView.layer.borderWidth = 1
        chosenColorView.layer.borderColor = UIColor.black.cgColor
        chosenColorView.layer.cornerRadius = 5

        chosenColorHexLabel.layer.borderWidth = 1
        chosenColorHexLabel.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        palleteView.delegate = self
        setting()
    }
}

extension ViewController: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        chosenColorView.backgroundColor = color
        chosenColorHexLabel.text = "#\(getStringFrom(color: color))"
    }
}

