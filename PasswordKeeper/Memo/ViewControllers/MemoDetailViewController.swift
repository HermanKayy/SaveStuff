//
//  MemoDetailViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/30/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

class MemoDetailViewController: UIViewController {
    
    var memo: Memo?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var colorButtons: [UIButton]!
    
    func setButtonColor() {
        guard let memo = memo else { return }
        switch memo.color {
        case "Gray":
            buttonSelectedState(colorButtons[0])
        case "Red":
            buttonSelectedState(colorButtons[1])
        case "Blue":
            buttonSelectedState(colorButtons[2])
        case "Yellow":
            buttonSelectedState(colorButtons[3])
        case "Green":
            buttonSelectedState(colorButtons[4])
        case "Purple":
            buttonSelectedState(colorButtons[5])
        default: return
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
    
    func resetColorButtons() {
        for button in colorButtons {
            buttonUnselectedState(button)
        }
    }
    
    func saveButtonColor() -> String {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = memo?.title
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.isHidden = true
        
        setupViews()
        titleTextField.delegate = self
        notesTextView.delegate = self
        notesTextView.inputAccessoryView = toolBar
        
        titleTextField.textContentType = UITextContentType("")
        notesTextView.textContentType = UITextContentType("")
        
        setButtonColor()
    }
    
    func setupViews() {
        guard let memo = memo else { return }
        titleTextField.text = memo.title
        notesTextView.text = memo.notes
    }
    
    
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToolbarButtonTapped))
        tb.items = [flex, done]
        return tb
    }()
    
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        resetColorButtons()
        if sender.isSelected {
            buttonUnselectedState(sender)
        } else {
            buttonSelectedState(sender)
        }
    }
    
    @objc func doneToolbarButtonTapped() {
        
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.notesTextView.resignFirstResponder()
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let memo = memo, let title = titleTextField.text, let notes = notesTextView.text else { return }
        MemoController.shared.updateMemo(memo: memo, title: title, notes: notes, color: saveButtonColor())
        navigationController?.popViewController(animated: true)
    }
}

extension MemoDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height / 3))
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}






