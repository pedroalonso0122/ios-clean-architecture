//
//  ProfileAPIService.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/9/16.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

class ProfileAPIService: NSObject, Requestable {

    static let instance = ProfileAPIService()
    
    func update(email: String, name: String, password: String, role: String, callback: @escaping Handler) {
        
        let params = [
            "email": email,
            "name": name,
            "password": password,
            "role": role
        ] as [String : Any]
        
        request(method: .put, url: APIEndpoint.profileURL, params: params) { (result) in
           callback(result)
        }
    }
}
