//
//  ResetPasswordViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/8/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import AudioToolbox

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.ColorPalette.themeColor
        navigationItem.title = "Reset Password"
        newPasswordTextField.becomeFirstResponder()
    }
    
    @IBAction func newPasswordTextDidChange(_ sender: UITextField) {
        guard let newPasswordText = newPasswordTextField.text else { return }
        if newPasswordText.count >= 6 {
            confirmPasswordTextField.becomeFirstResponder()
        }
    }
    @IBAction func confirmPasswordTextDidChange(_ sender: UITextField) {
        guard let confirmPasswordText = confirmPasswordTextField.text, let newPasswordText = newPasswordTextField.text else { return }
        if confirmPasswordText.count >= 6 && newPasswordText.count >= 6 {
            if newPasswordTextField.text != confirmPasswordText {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                let alert = UIAlertController(title: "Passwords do not match!", message: "Please double check and try again.", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .default) { (_) in
                    self.confirmPasswordTextField.resignFirstResponder()
                    self.newPasswordTextField.becomeFirstResponder()
                }
                alert.addAction(okay)
                present(alert, animated: true, completion: nil)
                newPasswordTextField.text = ""
                confirmPasswordTextField.text = ""
            } else {
                let stringArray = Array(confirmPasswordText)
                print(stringArray)
                var newPassword = [Int]()
                for character in stringArray {
                    guard let number = Int(String(character)) else { return }
                    newPassword.append(number)
                }
                print(newPassword)
                passwordController.userPassword.removeAll()
                passwordController.userPassword = newPassword
                passwordController.saveToLocalPersistence()
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private let passwordController = PasswordInputController.shared
}














