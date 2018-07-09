//
//  AddPasswordViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/12/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import AudioToolbox

class AddPasswordViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New"
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.isHidden = true 
        
        titleTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        notesTextView.delegate = self
        notesTextView.inputAccessoryView = toolBar
        
        
        titleTextField.textContentType = UITextContentType("")
        usernameTextField.textContentType = UITextContentType("")
        passwordTextField.textContentType = UITextContentType("")
        notesTextView.textContentType = UITextContentType("")
    }
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToolBarTapped))
        tb.items = [flex, done]
        return tb
    }()
    
    @objc func doneToolBarTapped() {
        
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.notesTextView.resignFirstResponder()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text, !title.isEmpty, let username = usernameTextField.text, !username.isEmpty, let passcode = passwordTextField.text, !passcode.isEmpty, let notes = notesTextView.text else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            let alert = UIAlertController(title: "Missing Information", message: "Please make sure to at least fill out title, username, and password", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
            return
        }
        PasswordController.shared.createNewPassword(title: title, username: username, passcode: passcode, notes: notes)
        navigationController?.popViewController(animated: true)
    }
}

extension AddPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true 
    }
}

extension AddPasswordViewController: UITextViewDelegate {
    
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










