//
//  DateUtil.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/11/3.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

class DateUtil: NSObject {

    static let instance = DateUtil()

    func getDate() -> String {
        let inMillis = Date().timeIntervalSince1970

        return String(format: "%d", inMillis)
    }
    
}
