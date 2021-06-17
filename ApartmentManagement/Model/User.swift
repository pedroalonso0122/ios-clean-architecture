//
//  User.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/27.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit
import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let name: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case name = "name"
        case role = "role"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        email = try values.decode(String.self, forKey: .email)
        name = try values.decode(String.self, forKey: .name)
        role = try values.decode(String.self, forKey: .role)
    }
}
