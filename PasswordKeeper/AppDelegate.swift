//
//  AppDelegate.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/3/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: DidFinishLaunching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AutoFaceTouchController.shared.autoFaceTouch.isOn = UserDefaults.standard.bool(forKey: "AutoFaceTouch")
        return true
    }
    
    // MARK: WillEnterForeground
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "PasswordViewController") as? MainScreenViewController else { return }
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

