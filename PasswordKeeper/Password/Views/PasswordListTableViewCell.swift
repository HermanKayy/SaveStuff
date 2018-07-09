//
//  PasswordListTableViewCell.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/11/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

protocol PasswordListTableViewCellDelegate: class {
    func lockButtonPressed(_ sender: PasswordListTableViewCell)
    func lockButtonReleased(_ sender: PasswordListTableViewCell)
}

class PasswordListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellContainerView: UIView!
    
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var lockButtonImage: UIImageView!
    @IBOutlet weak var lockButton: UIButton!
    
    weak var delegate: PasswordListTableViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lockButton.layer.cornerRadius = 20
        
        cellContainerView.layer.masksToBounds = false
        cellContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellContainerView.layer.shadowRadius = 2
        cellContainerView.layer.shadowColor = UIColor.black.cgColor
        cellContainerView.layer.shadowOpacity = 0.6
    }
    
    @IBAction func lockTouchDown(_ sender: UIButton) {
        delegate?.lockButtonPressed(self)
        passwordLabel.numberOfLines = 2
    }
    
    @IBAction func lockTouchUpInside(_ sender: UIButton) {
        delegate?.lockButtonReleased(self)
        passwordLabel.numberOfLines = 1
    }
    
    @IBAction func lockTouchUpOutside(_ sender: UIButton) {
        delegate?.lockButtonReleased(self)
        passwordLabel.numberOfLines = 1
    }
    
    func lockIsPressed(password: Password) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        lockButtonImage.image = #imageLiteral(resourceName: "unlock")
        guard let username = password.username, let passcode = password.passcode else { return }
        passwordLabel.font = UIFont.systemFont(ofSize: 13)
        passwordLabel.text = "\(username) \n \(passcode)"
    }
    
    func lockIsReleased(password: Password) {
        lockButtonImage.image = #imageLiteral(resourceName: "lock")
        passwordLabel.font = UIFont.boldSystemFont(ofSize: 30)
        passwordLabel.text = password.title
    }
}







