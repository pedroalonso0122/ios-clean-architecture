//
//  AuthManager.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/30.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

class AuthManager {
    /// The default singleton instance.
    static let shared = AuthManager()

    var token: String?
    
    var userInfo: User?

    var hasValidToken: Bool {
        return token != nil
    }
    
    func login(token: String, userInfo: User) {
        AuthManager.shared.token = token
        AuthManager.shared.userInfo = userInfo
    }
    
    func logout() {
        AuthManager.shared.token = nil
        AuthManager.shared.userInfo = nil
    }
    
    func saveCredential(type: String, email: String, password: String) {
        let defaults = UserDefaults.standard
        defaults.set(type, forKey: "Type")
        defaults.set(email, forKey: "Email")
        defaults.set(password, forKey: "Password")
    }
    
    func updateEmail(email: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "Email")
    }
    
    func updatePassword(password: String) {
        let defaults = UserDefaults.standard
        defaults.set(password, forKey: "Password")
    }
    
    func removeCredentail() {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "Type")
        defaults.set("", forKey: "Email")
        defaults.set("", forKey: "Password")
    }
    
    func getType() -> String {
        return  UserDefaults.standard.string(forKey: "Type") ?? ""
    }
    
    func getEmail() -> String {
        return  UserDefaults.standard.string(forKey: "Email") ?? ""
    }
    
    func getPassword() -> String {
        return  UserDefaults.standard.string(forKey: "Password") ?? ""
    }
}
