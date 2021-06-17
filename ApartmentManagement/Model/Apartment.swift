//
//  Apartment.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/31.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

struct Apartment: Codable {
    let id: Int
    let realtorId: Int
    let realtorName: String
    let name: String
    let description: String
    let floorAreaSize: Int
    let price: Int
    let numberOfRooms: Int
    let country: String
    let locality: String
    let address: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let status: Int
    
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case realtorId = "realtor_id"
        case realtorName = "realtor_name"
        case name = "name"
        case description = "description"
        case floorAreaSize = "floor_area_size"
        case price = "price"
        case numberOfRooms = "number_of_rooms"
        case country = "country"
        case locality = "locality"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case image = "image"
        case status = "status"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        realtorId = try values.decode(Int.self, forKey: .realtorId)
        realtorName = try values.decode(String.self, forKey: .realtorName)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        floorAreaSize = try values.decode(Int.self, forKey: .floorAreaSize)
        price = try values.decode(Int.self, forKey: .price)
        numberOfRooms = try values.decode(Int.self, forKey: .numberOfRooms)
        country = try values.decode(String.self, forKey: .country)
        locality = try values.decode(String.self, forKey: .locality)
        address = try values.decode(String.self, forKey: .address)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        status = try values.decode(Int.self, forKey: .status)
        createdAt = try values.decode(String.self, forKey: .createdAt)
    }
}
