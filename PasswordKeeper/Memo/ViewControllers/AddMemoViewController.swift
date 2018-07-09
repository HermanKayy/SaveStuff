//
//  AddMemoViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/29/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import AudioToolbox

class AddMemoViewController: UIViewController {
    
    var memo: Memo? 

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet var colorButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        titleTextField.delegate = self
        notesTextView.delegate = self
        notesTextView.inputAccessoryView = toolBar
        
        titleTextField.textContentType = UITextContentType("")
        notesTextView.textContentType = UITextContentType("")
        if let firstButton = colorButtons.first {
            buttonSelectedState(firstButton)
        }
    }
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToolBarTapped))
        tb.items = [flex, done]
        return tb
    }()
    
    func resetColorButtons() {
        for button in colorButtons {
            buttonUnselectedState(button)
        }
    }
    
    func setButtonColor() -> String {
        var colorSelected = "Gray"
        for (index, button) in colorButtons.enumerated() {
            if button.isSelected {
                switch index {
                case 0: colorSelected = "Gray"
                case 1: colorSelected = "Red"
                case 2: colorSelected = "Blue"
                case 3: colorSelected = "Yellow"
                case 4: colorSelected = "Green"
                case 5: colorSelected = "Purple"
                default: colorSelected = "Gray"
                }
            }
        }
        return colorSelected
    }
    
    @IBAction func colorButtonPpressed(_ sender: UIButton) {
        resetColorButtons()
        if sender.isSelected {
            buttonUnselectedState(sender)
        } else {
            buttonSelectedState(sender)
        }
    }
    
    func buttonSelectedState(_ sender: UIButton) {
        sender.isSelected = true
        sender.layer.borderColor = UIColor.white.cgColor
        sender.layer.borderWidth = 3
        sender.layer.opacity = 1
    }
    
    func buttonUnselectedState(_ sender: UIButton) {
        sender.isSelected = false
        sender.layer.borderColor = UIColor.clear.cgColor
        sender.layer.opacity = 0.3
    }
    
    
    @objc func doneToolBarTapped() {
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.notesTextView.resignFirstResponder()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let notes = notesTextView.text, !notes.isEmpty else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            let alert = UIAlertController(title: "Missing Information", message: "Please make sure to fill out title and notes field", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
            return
        }
        
        MemoController.shared.createNewMemo(title: title, notes: notes, color: setButtonColor())
        navigationController?.popViewController(animated: true)
    }
}

extension AddMemoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

extension AddMemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height / 3.5))
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}







