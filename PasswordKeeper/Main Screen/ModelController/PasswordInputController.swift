//
//  PasswordController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/7/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation

class PasswordInputController {
    
    static let shared = PasswordInputController()
    
    var userPassword = [Int]()
    var passwordInput = [Int]()
    
    func addUserPasswordInput(number: Int) {
        userPassword.append(number)
    }
    
    func deleteUserInput() {
        userPassword.remove(at: userPassword.count - 1)
        saveToLocalPersistence()
    }
    
    func addPasscodeInput(number: Int) {
        passwordInput.append(number)
    }
    
    func deletePasscodeInput() {
        passwordInput.remove(at: passwordInput.count - 1)
    }
    
    func fileURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = documentsDirectory[0]
        let fullURL = fileName.appendingPathComponent("password").appendingPathExtension("json")
        return fullURL
    }
    
    func saveToLocalPersistence() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(userPassword)
            try data.write(to: fileURL())
        } catch {
            print("❌ Encoding Error", error)
        }
    }
    
    func loadFromLocalPersistence() -> [Int] {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let password = try jsonDecoder.decode([Int].self, from: data)
            return password
        } catch {
            print("❌ Decoding Error", error)
        }
        return []
    }
    
    private init() {
        userPassword = loadFromLocalPersistence()
    }
}











