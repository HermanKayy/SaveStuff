//
//  PasswordViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/3/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import LocalAuthentication
import AudioToolbox

class MainScreenViewController: UIViewController {
    
    // MARK: Properties
    var userFirstDownload = false
    
    // MARK: IBOutlets
    @IBOutlet weak var passwordOne: UITextField!
    @IBOutlet weak var passwordTwo: UITextField!
    @IBOutlet weak var passwordThree: UITextField!
    @IBOutlet weak var passwordFour: UITextField!
    @IBOutlet weak var passwordFive: UITextField!
    @IBOutlet weak var passwordSix: UITextField!
    @IBOutlet weak var faceTouchButton: UIButton!
    @IBOutlet weak var faceTouchLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var textFieldCover: UIView!
    @IBOutlet weak var textFieldStack: UIStackView!
    
    // MARK: LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AutoFaceTouchController.shared.autoFaceTouch.isOn == true {
            LocalAuthentication.shared.handleFaceTouchAuthentication { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showVC", sender: self)
                    }
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            textFieldCover.translatesAutoresizingMaskIntoConstraints = false
            textFieldCover.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textFieldCover.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textFieldCover.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight - 20).isActive = true
     
            textFieldStack.translatesAutoresizingMaskIntoConstraints = false
            textFieldStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textFieldStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textFieldStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight - 20).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupAuthenticationLabel()
        setupAuthentication()
        UIApplication.shared.statusBarStyle = .default
        animateCircleView()
    }
    
    // MARK: IBActions
    @IBAction func faceTouchButtonTapped(_ sender: UIButton) {
        LocalAuthentication.shared.handleFaceTouchAuthentication { (success) in
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showVC", sender: self)
                }
            }
        }
    }
    
    // MARK: Setup Textfields
    func setupTextFields() {
        passwordOne.becomeFirstResponder()
        passwordOne.delegate = self
        passwordOne.tintColor = UIColor.clear
        passwordTwo.delegate = self
        passwordTwo.tintColor = UIColor.clear
        passwordThree.delegate = self
        passwordThree.tintColor = UIColor.clear
        passwordFour.delegate = self
        passwordFour.tintColor = UIColor.clear
        passwordFive.delegate = self
        passwordFive.tintColor = UIColor.clear
        passwordSix.delegate = self
        passwordSix.tintColor = UIColor.clear
        
        passwordOne.layer.cornerRadius = 15
        passwordTwo.layer.cornerRadius = 15
        passwordThree.layer.cornerRadius = 15
        passwordFour.layer.cornerRadius = 15
        passwordFive.layer.cornerRadius = 15
        passwordSix.layer.cornerRadius = 15
    }
    
    // MARK: Setup Authentication
    func setupAuthentication() {
        if userFirstDownload != true {
            switch LocalAuthentication.shared.biometricType() {
            case .faceID:
                faceTouchLabel.text = "or\n \nEnter Password"
                faceTouchButton.setBackgroundImage(#imageLiteral(resourceName: "faceTouchIcon"), for: .normal)
            case .touchID:
                faceTouchLabel.text = "or\n \nEnter Password"
                faceTouchButton.setBackgroundImage(#imageLiteral(resourceName: "faceTouchIcon"), for: .normal)
            case .none:
                faceTouchButton.isHidden = true
            }
        } else {
            faceTouchButton.isHidden = true
        }
    }
    
    // MARK: Setup Authentication Label
    func setupAuthenticationLabel() {
        if passwordController.userPassword.isEmpty {
            faceTouchLabel.text = "Create A Passcode"
            userFirstDownload = true
        }
    }
    
    // MARK: Handle Wrong Password
    func handleWrongPassword() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        clearTextFields()
        let alert = UIAlertController(title: "Incorrect Passcode", message: "Please try again", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.passwordController.passwordInput.removeAll()
            self.passwordSix.resignFirstResponder()
            self.passwordOne.becomeFirstResponder()
        }
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
    }
    
    func clearTextFields() {
        passwordOne.text = ""
        passwordTwo.text = ""
        passwordThree.text = ""
        passwordFour.text = ""
        passwordFive.text = ""
        passwordSix.text = ""
        passwordOne.backgroundColor = UIColor.white
        passwordTwo.backgroundColor = UIColor.white
        passwordThree.backgroundColor = UIColor.white
        passwordFour.backgroundColor = UIColor.white
        passwordFive.backgroundColor = UIColor.white
        passwordSix.backgroundColor = UIColor.white
    }
    
    func animateCircleView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
            self.faceTouchButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })

        UIView.animate(withDuration: 0.3, delay: 0.3, options: [.allowUserInteraction], animations: {
            self.faceTouchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })

        UIView.animate(withDuration: 0.3, delay: 0.6, options: [.allowUserInteraction], animations: {
            self.faceTouchButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })

        UIView.animate(withDuration: 1.4, delay: 0.3, options: [.allowUserInteraction], animations: {
            self.circleView.isHidden = false
            self.circleView.transform = CGAffineTransform(scaleX: 20, y: 20)
            self.circleView.alpha = 0
        })
        
        UIView.animate(withDuration: 0.75, delay: 2.3, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
            self.faceTouchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }
    
    private let passwordController = PasswordInputController.shared
}

// MARK: TextField Delegate
extension MainScreenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        switch textField {
        case passwordOne:
            if text.count != 1 {
                textField.text = string
                passwordOne.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)
                if userFirstDownload {
                    passwordController.addUserPasswordInput(number: Int(string) ?? 0)
                } else {
                    passwordController.addPasscodeInput(number: Int(string) ?? 0)
                }
                return false
            } else if string == "" {
                textField.text = ""
                passwordOne.backgroundColor = UIColor.white
                if userFirstDownload {
                    passwordController.deleteUserInput()
                } else {
                    passwordController.deletePasscodeInput()
                }
                return false
            } else {
                textField.resignFirstResponder()
                passwordTwo.becomeFirstResponder()
                passwordTwo.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)

                if userFirstDownload {
                    passwordController.addUserPasswordInput(number: Int(string) ?? 0)
                    print("userPasscode", PasswordInputController.shared.userPassword)
                } else {
                    passwordController.addPasscodeInput(number: Int(string) ?? 0)
                }
                return true
            }
            
        case passwordTwo:
            if string == "" {
                textField.text = ""
                passwordTwo.backgroundColor = UIColor.white
                textField.resignFirstResponder()
                passwordOne.becomeFirstResponder()
                if userFirstDownload {
                    passwordController.deleteUserInput()
                } else {
                    passwordController.deletePasscodeInput()
                }
                return false
            } else {
                textField.resignFirstResponder()
                passwordThree.becomeFirstResponder()
                passwordThree.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)

                if userFirstDownload {
                    passwordController.addUserPasswordInput(number: Int(string) ?? 0)
                } else {
                    passwordController.addPasscodeInput(number: Int(string) ?? 0)
                }
                return true
            }
            
        case passwordThree:
            if string == "" {
                textField.text = ""
                textField.resignFirstResponder()
                passwordTwo.becomeFirstResponder()
                passwordThree.backgroundColor = UIColor.white
                if userFirstDownload {
                    passwordController.deleteUserInput()
                } else {
                    passwordController.deletePasscodeInput()
                }
                return false
            } else {
                textField.resignFirstResponder()
                passwordFour.becomeFirstResponder()
                passwordFour.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)

                if userFirstDownload {
                    passwordController.addUserPasswordInput(number: Int(string) ?? 0)
                } else {
                    passwordController.addPasscodeInput(number: Int(string) ?? 0)
                }
                return true
            }
            
        case passwordFour:
            if string == "" {
                textField.text = ""
                textField.resignFirstResponder()
                passwordThree.becomeFirstResponder()
                passwordFour.backgroundColor = UIColor.white
                if userFirstDownload {
                    passwordController.deleteUserInput()
                } else {
                    passwordController.deletePasscodeInput()
                }
                return false
            } else {
                textField.resignFirstResponder()
                passwordFive.becomeFirstResponder()
                passwordFive.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)

                if userFirstDownload {
                    passwordController.addUserPasswordInput(number: Int(string) ?? 0)
                    print("userPasscode", PasswordInputController.shared.userPassword)
                } else {
                    passwordController.addPasscodeInput(number: Int(string) ?? 0)
                    print(PasswordInputController.shared.passwordInput)
                }
                return true
            }
            
        case passwordFive:
            if string == "" {
                textField.text = ""
                textField.resignFirstResponder()
                passwordFour.becomeFirstResponder()
                passwordFive.backgroundColor = UIColor.white
                if userFirstDownload {
                    passwordController.deleteUserInput()
                } else {
                    passwordController.deletePasscodeInput()
                }
                return false
            } else {
                textField.resignFirstResponder()
                passwordSix.becomeFirstResponder()
                passwordSix.backgroundColor = UIColor(red: 144/255.0, green: 175/255.0, blue: 197/255.0, alpha: 1.0)

                if userFirstDownload {
                    passwordController.addUserPasswordInput(number: Int(string) ?? 0)
                    passwordController.saveToLocalPersistence()
                    performSegue(withIdentifier: "showVC", sender: self)
                } else {
                    PasswordInputController.shared.addPasscodeInput(number: Int(string) ?? 0)
                    if passwordController.passwordInput == passwordController.userPassword {
                        passwordSix.text = string 
                        passwordController.passwordInput.removeAll()
                        performSegue(withIdentifier: "showVC", sender: self)
                    } else {
                        passwordSix.text = string
                        handleWrongPassword()
                    }
                }
                return true
            }
            
        default:
            return false
        }
    }

}








