//
//  Filter.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/10/30.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

struct Filter {
    var country: String?
    var locality: String?
    
    var minPrice: String
    var maxPrice: String
    var priceText: String
    
    var minAreaSize: String
    var maxAreaSize: String
    var areaSizeText: String
    
    var minNumberRooms: String
    var maxNumberRooms: String
    var numberRoomText: String
}
