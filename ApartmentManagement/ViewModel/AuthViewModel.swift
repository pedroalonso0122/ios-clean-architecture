//
//  UserViewModel.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/27.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation
import SwiftyJSON

class AuthViewModel: BaseViewModel {

    func login(email: String, password: String) {
        // State -> Waiting
        self.handleWaiting()
        
        // Call API
        AuthAPIService.instance.login(email: email, password: password, callback: { result in
            switch result {
            case .success(let data):
                let result = JSON(data)
                
                let token: String = result["token"].stringValue
                
                guard let user = try? JSONDecoder().decode(User.self, from: result["user"].rawData()) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                
                AuthManager.shared.login(token: token, userInfo: user)
                
                // Save Login Information in User Default
                AuthManager.shared.saveCredential(type: LoginType.email.rawValue, email: email, password: password)
                
                self.handleSuccess()
                
                break
            case .failure(let error):
                self.handleError(error: error)
            }
        })
    }
    
    func socialLogin(provider: String, token: String) {
        // State -> Waiting
        self.handleWaiting()
        
        // Call API
        AuthAPIService.instance.socialLogin(provider: provider, accessToken: token, callback: { result in
            switch result {
            case .success(let data):
                let result = JSON(data)
                
                let token: String = result["token"].stringValue
                
                guard let user = try? JSONDecoder().decode(User.self, from: result["user"].rawData()) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                
                AuthManager.shared.login(token: token, userInfo: user)
                
                // Save Login Information in User Default
                AuthManager.shared.saveCredential(type: provider, email: user.email, password: "")
                
                self.handleSuccess()
                
                break
            case .failure(let error):
                self.handleError(error: error)
            }
        })
    }
    
    func register(email: String, name: String, password: String, role: String) {
        // State -> Waiting
        self.handleWaiting()
        
        AuthAPIService.instance.register(email: email, name: name, password: password, role: role, callback: { result in
            
            switch result {
            case .success(let data):
                let result = JSON(data)
                
                let token: String = result["token"].stringValue
                
                guard let user = try? JSONDecoder().decode(User.self, from: result["user"].rawData()) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                
                AuthManager.shared.login(token: token, userInfo: user)
                
                // Save Email/Password in User Default
                AuthManager.shared.saveCredential(type: LoginType.email.rawValue, email: email, password: password)
                
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
            }
        })
    }
    
}
