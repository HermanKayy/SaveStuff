//
//  SettingsTableViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/9/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var autoFaceTouchIsOn: UISwitch!
    @IBAction func faceTouchIDSwitch(_ sender: UISwitch) {
        AutoFaceTouchController.shared.toggleIsOn()
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationItem.title = "Settings"
        
        if AutoFaceTouchController.shared.autoFaceTouch.isOn == true {
            autoFaceTouchIsOn.isOn = true 
        } else {
            autoFaceTouchIsOn.isOn = false
        }
    }
    
    func requestToRate() {
        SKStoreReviewController.requestReview()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            requestToRate()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
