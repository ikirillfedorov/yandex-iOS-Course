//
//  EditNoteViewController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 15/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    var selectedNote: Note?
    var colorFromColorPicker: UIColor?
    
    //MARK: - IB Outlets
    @IBOutlet var colorViews: [CheckMarkView]!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var importanceSegmentControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - IB Outlets constrains
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - IB Actions
    @IBAction func palleteViewLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            performSegue(withIdentifier: "ShowColorPicker", sender: nil)
        }
        
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let navController = navigationController as? NotesNavController else { return }
        var noteColor: UIColor?
        for colorView in colorViews {
            if colorView.isHasCheckMark {
                noteColor = colorView.backgroundColor
            }
        }
        let newNote = Note(uid: selectedNote?.uid,
                           title: titleTextField.text ?? "",
                           content: contentTextView.text,
                           noteColor: noteColor,
                           importance: .important,
                           destractionDate: datePicker.date)
        navController.notebook.add(newNote)
        
        navController.popViewController(animated: true)
        navController.saveNotesQueue.addOperation(SaveNoteOperation(note: newNote,
                                                      notebook: navController.notebook,
                                                      backendQueue: navController.backendQueue,
                                                      dbQueue: navController.dbQueue))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ColorPickerViewController, segue.identifier == "ShowColorPicker" else { return }
        controller.delegate = self
        
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
//        colorViews[0].isHasCheckMark = true //default check mark
        for view in colorViews {
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 1
        }
        
        colorViews[0].backgroundColor = .white
        colorViews[1].backgroundColor = .red
        colorViews[2].backgroundColor = .green

        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
        
        saveButton.layer.cornerRadius = 5
        
        datePicker.minimumDate = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let note = selectedNote {

            titleTextField.text = note.title
            contentTextView.text = note.content
            
            switch note.importance.rawValue {
            case "unimportant":
                importanceSegmentControl.selectedSegmentIndex = 0
            case "ordinary":
                importanceSegmentControl.selectedSegmentIndex = 1
            default:
                importanceSegmentControl.selectedSegmentIndex = 1
            }
            
            if colorFromColorPicker == nil {
                switch note.noteColor {
                case .white:
                    colorViews[0].isHasCheckMark = true
                case .red:
                    colorViews[1].isHasCheckMark = true
                case .green:
                    colorViews[2].isHasCheckMark = true
                default:
                    colorViews[3].isHasCheckMark = true
                    colorViews[3].backgroundColor = note.noteColor
                }
            }

            guard let date = note.destractionDate else { return }
            datePicker.date = date
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        
        //MARK: - keyboard hitifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViw), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViw), name: UIResponder.keyboardWillHideNotification, object: nil)
        setting()
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
extension EditNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

extension EditNoteViewController: ColorPickerDelegate {
    func chosenColor(color: UIColor) {
        colorFromColorPicker = color
        colorViews[3].backgroundColor = color
        for view in colorViews {
            view.isHasCheckMark = view === colorViews[3]
            view.setNeedsDisplay()
        }
    }
}





