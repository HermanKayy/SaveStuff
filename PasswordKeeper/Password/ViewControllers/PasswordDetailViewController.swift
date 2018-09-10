//
//  ItemDetailViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/7/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

class PasswordDetailViewController: UIViewController {
    
    var passwword: Password?
    var passwordButtonIsTapped = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = passwword?.title
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.isHidden = true 
            
        setupViews()
        titleTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        notesTextView.inputAccessoryView = toobar
        notesTextView.delegate = self 
        
        titleTextField.textContentType = UITextContentType("")
        usernameTextField.textContentType = UITextContentType("")
        passwordTextField.textContentType = UITextContentType("")
        notesTextView.textContentType = UITextContentType("")
    }
    
    let toobar: UIToolbar = {
        let tb = UIToolbar()
        tb.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToolbarButtonTapped))
        tb.items = [flex, done]
        return tb
    }()

    @objc func doneToolbarButtonTapped() {
        
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.notesTextView.resignFirstResponder()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let password = passwword, let title = titleTextField.text, let username = usernameTextField.text, let passcode = passwordTextField.text, let notes = notesTextView.text else { return }
        PasswordController.shared.updatePassword(password: password, title: title, username: username, passcode: passcode, notes: notes)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func releaseButton(_ sender: UIButton) {
        passwordButtonIsTapped = false
        showPasswordButton.isHighlighted = false
        showPasswordButton.setTitle("Show Password", for: .normal)
        showPasswordButton.setTitleColor(UIColor(red: 0/255.0, green: 150/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        passwordTextField.isSecureTextEntry = true
    }
    
    
    @IBAction func showPasswordButtonTapped(_ sender: UIButton) {
        showPasswordButton.isHighlighted = true
        showPasswordButton.setTitle("Hide Password", for: .normal)
        showPasswordButton.setTitleColor(UIColor.lightGray, for: .normal)
        passwordTextField.isSecureTextEntry = false
    }
    
    @IBAction func test(_ sender: UIButton) {
        showPasswordButton.isHighlighted = false
        showPasswordButton.setTitle("Show Password", for: .normal)
        showPasswordButton.setTitleColor(UIColor(red: 0/255.0, green: 150/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        passwordTextField.isSecureTextEntry = true
    }
    
    func setupViews() {
        guard let password = passwword else { return }
        titleTextField.text = password.title
        usernameTextField.text = password.username
        passwordTextField.text = password.passcode
        notesTextView.text = password.notes
    }
}

extension PasswordDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

extension PasswordDetailViewController: UITextViewDelegate {
    
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





