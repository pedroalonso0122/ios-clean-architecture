//
//  ApartmentAPIService.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/31.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

class ApartmentAPIService: NSObject, Requestable {

    static let instance = ApartmentAPIService()
    
    func load(country: String?, locality: String?, minPrice: String?, maxPrice: String?, minAreaSize: String?, maxAreaSize: String?, minNumberRooms: String?, maxNumberRooms: String?, status: Int?, callback: @escaping Handler) {
        
        let params = [
            "country": country ?? "",
            "locality": locality ?? "",
            "min_price": minPrice ?? "",
            "max_price": maxPrice ?? "",
            "min_size": minAreaSize ?? "",
            "max_size": maxAreaSize ?? "",
            "min_number_rooms": minNumberRooms ?? "",
            "max_number_rooms": maxNumberRooms ?? "",
            "status": status ?? "",
        ] as [String : Any]
        
        request(method: .get, url: APIEndpoint.apartmentURL, params: params) { (result) in
           callback(result)
        }
    }
    
    func add(realtorId: Int, name: String, description: String, floorAreaSize: Int, price: Int, numberOfRooms: Int, country: String, locality: String, address: String, latitude: Double, longitude: Double, image: Data, status: Int,  callback: @escaping Handler) {
        
        let params = [
            "realtor_id": realtorId,
            "name": name,
            "description": description,
            "floor_area_size": floorAreaSize,
            "price": price,
            "number_of_rooms": numberOfRooms,
            "country": country,
            "locality": locality,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "status" : status
        ] as [String : Any]
        
        request(method: .post, url: APIEndpoint.apartmentURL, imgData: image, parameters: params) { (result) in
           callback(result)
        }
    }
    
    func update(id: Int, realtorId: Int, name: String, description: String, floorAreaSize: Int, price: Int, numberOfRooms: Int, country: String, locality: String, address: String, latitude: Double, longitude: Double, image: Data, status: Int, callback: @escaping Handler) {
    
        let params = [
            "realtor_id": realtorId,
            "name": name,
            "description": description,
            "floor_area_size": floorAreaSize,
            "price": price,
            "number_of_rooms": numberOfRooms,
            "country": country,
            "locality": locality,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "status" : status
        ] as [String : Any]
        
        request(method: .post, url: APIEndpoint.apartmentURL + "/" + String(id), imgData: image, parameters: params) { (result) in
           callback(result)
        }
    }
    
    func delete(id: Int, callback: @escaping Handler) {
        request(method: .delete, url: APIEndpoint.apartmentURL + "/" + String(id), params: nil) { (result) in
           callback(result)
        }
    }
}
