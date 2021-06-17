//
//  ProfileViewModel.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/9/5.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

class ProfileViewModel: BaseViewModel {

    func update(id: Int, email: String, name: String, password: String, role: String) {
        // State -> Waiting
        self.handleWaiting()
        
        ProfileAPIService.instance.update(email: email ,name: name, password: password, role: role, callback: { result in
            
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }

                // Update userInfo
                AuthManager.shared.userInfo = user
                
                // Update saved credential
                if !email.isEmpty {
                    AuthManager.shared.updateEmail(email: email)
                }
                if !password.isEmpty {
                    AuthManager.shared.updatePassword(password: password)
                }
                
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
}
