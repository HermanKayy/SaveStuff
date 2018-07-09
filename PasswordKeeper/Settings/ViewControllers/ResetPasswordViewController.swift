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

//extension ResetPasswordViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        guard let text = textField.text else { return true }
//        switch textField {
//        case passwordOne:
//            if text.count != 1 {
//                textField.text = string
//                passwordOne.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)
//                passwordController.addPasscodeInput(number: Int(string) ?? 0)
//                return false
//            } else if string == "" {
//                textField.text = ""
//                passwordOne.backgroundColor = UIColor.white
//                passwordController.deletePasscodeInput()
//
//                return false
//            } else {
//                textField.resignFirstResponder()
//                passwordTwo.becomeFirstResponder()
//                passwordTwo.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)
//                passwordController.addPasscodeInput(number: Int(string) ?? 0)
//                return true
//            }
//
//        case passwordTwo:
//            if string == "" {
//                textField.text = ""
//                passwordTwo.backgroundColor = UIColor.white
//                textField.resignFirstResponder()
//                passwordOne.becomeFirstResponder()
//                passwordController.deletePasscodeInput()
//                return false
//            } else {
//                textField.resignFirstResponder()
//                passwordThree.becomeFirstResponder()
//                passwordThree.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)
//                passwordController.addPasscodeInput(number: Int(string) ?? 0)
//
//                return true
//            }
//
//        case passwordThree:
//            if string == "" {
//                textField.text = ""
//                textField.resignFirstResponder()
//                passwordTwo.becomeFirstResponder()
//                passwordThree.backgroundColor = UIColor.white
//                passwordController.deletePasscodeInput()
//                return false
//            } else {
//                textField.resignFirstResponder()
//                passwordFour.becomeFirstResponder()
//                passwordFour.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)
//                passwordController.addPasscodeInput(number: Int(string) ?? 0)
//
//                return true
//            }
//
//        case passwordFour:
//            if string == "" {
//                textField.text = ""
//                textField.resignFirstResponder()
//                passwordThree.becomeFirstResponder()
//                passwordFour.backgroundColor = UIColor.white
//                passwordController.deletePasscodeInput()
//                return false
//            } else {
//                textField.resignFirstResponder()
//                passwordFive.becomeFirstResponder()
//                passwordFive.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)
//                passwordController.addPasscodeInput(number: Int(string) ?? 0)
//
//                return true
//            }
//
//        case passwordFive:
//            if string == "" {
//                textField.text = ""
//                textField.resignFirstResponder()
//                passwordFour.becomeFirstResponder()
//                passwordFive.backgroundColor = UIColor.white
//                passwordController.deletePasscodeInput()
//                return false
//            } else {
//                textField.resignFirstResponder()
//                passwordSix.becomeFirstResponder()
//                passwordSix.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)
//                passwordController.addPasscodeInput(number: Int(string) ?? 0)
//                passwordController.userPassword.removeAll()
//                passwordController.userPassword = PasswordInputController.shared.passwordInput
//                passwordController.passwordInput.removeAll()
//                passwordController.saveToLocalPersistence()
//
//                navigationController?.popViewController(animated: true)
//                return true
//            }
//
//        default:
//            return false
//        }
//    }
//}















