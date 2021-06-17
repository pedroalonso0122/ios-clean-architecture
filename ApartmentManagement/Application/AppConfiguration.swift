//
//  AppConfiguration.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/28.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation


struct APIEndpoint {
    static let apiBaseURL: String = "http://192.168.31.42:8000"
    
    static let loginURL: String = apiBaseURL + "/api/auth/login"
    static let socialLoginURL: String = apiBaseURL + "/api/auth/token"
    static let registerURL: String = apiBaseURL + "/api/auth/register"
    static let apartmentURL: String = apiBaseURL + "/api/apartments"
    static let userURL: String = apiBaseURL + "/api/users"
    static let profileURL: String = apiBaseURL + "/api/profile"
    
    static let imageURL: String = apiBaseURL + "/images/";
}

let GOOGLE_CLIENT_ID: String = ""

let GOOGLE_API_KEY: String = ""

let FILTER_FLOOR_AREA_SIZE_MAX = 7500
let FILTER_NUMBER_OM_ROOMS_MAX = 5
let FILTER_PRICE_MAX = 10000

enum Role: String, CaseIterable {
    case admin = "Admin"
    case realtor = "Realtor"
    case client = "Client"

    init?(id : Int) {
        switch id {
        case 0: self = .admin
        case 1: self = .realtor
        case 2: self = .client
        default: return nil
        }
    }
}

enum MenuType: String {
    case apartment
    case user
    case profile
    case logout
}

enum ActionState {
    case none
    case success
    case fail
    case waiting
    case uploadSuccess
}

enum RentStatus: Int {
    case available = 1
    case rented = 2
}

enum LoginType: String {
    case email = "email"
    case google = "google"
    case facebook = "facebook"
}
