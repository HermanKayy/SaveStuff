//
//  AutoFaceTouchController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/30/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation

class AutoFaceTouchController {
    
    static let shared = AutoFaceTouchController()
    var autoFaceTouch = AutoFaceTouch()
    
    func toggleIsOn() {
        if autoFaceTouch.isOn == false {
            autoFaceTouch.isOn = true
            UserDefaults.standard.set(true, forKey: "AutoFaceTouch")
        } else {
            autoFaceTouch.isOn = false
            UserDefaults.standard.set(false, forKey: "AutoFaceTouch")
        }
    }
}
