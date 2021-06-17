//
//  ApartmentViewModel.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/31.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApartmentViewModel: BaseViewModel {

    var startDate: String = ""
    var endDate: String = ""
    
    var apartments: Observable<[Apartment]> = Observable([])
    
    var fileName: String = ""
    
    func load(country: String?, locality: String?, minPrice: String?, maxPrice: String?, minAreaSize: String?, maxAreaSize: String?, minNumberRooms: String?, maxNumberRooms: String?) {
        // State -> Waiting
        self.handleWaiting()
        
        
        var status: Int?
        
        let role = AuthManager.shared.userInfo?.role
        
        if role == Role.client.rawValue {
            status = RentStatus.available.rawValue
        }
        
        ApartmentAPIService.instance.load(country: country, locality: locality, minPrice: minPrice, maxPrice: maxPrice, minAreaSize: minAreaSize, maxAreaSize: maxAreaSize, minNumberRooms: minNumberRooms, maxNumberRooms: maxNumberRooms, status: status, callback: { result in
            switch result {
            case .success(let data):
                guard let apartments = try? JSONDecoder().decode([Apartment].self, from: data) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                self.handleSuccess()
                self.apartments.value = apartments
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
    func add(name: String, description: String, floorAreaSize: Int, price: Int, numberOfRooms: Int, country: String, locality: String, address: String, latitude: Double, longitude: Double, image: Data, status: Int) {
        // State -> Waiting
        self.handleWaiting()
        
        guard let userId = AuthManager.shared.userInfo?.id else {
            self.handleError(error: "No User Id")
            return
        }
        
        ApartmentAPIService.instance.add(realtorId: userId ,name: name, description: description, floorAreaSize: floorAreaSize, price: price, numberOfRooms: numberOfRooms, country: country, locality: locality, address: address, latitude: latitude, longitude: longitude, image: image, status: status, callback: { result in
            
            switch result {
            case .success( _):
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
    func update(id: Int, realtorId: Int, name: String, description: String, floorAreaSize: Int, price: Int, numberOfRooms: Int, country: String, locality: String, address: String, latitude: Double, longitude: Double, image: Data, status: Int) {

        // State -> Waiting
        self.handleWaiting()
        
        ApartmentAPIService.instance.update(id: id, realtorId: realtorId ,name: name, description: description, floorAreaSize: floorAreaSize, price: price, numberOfRooms: numberOfRooms, country: country, locality: locality, address: address, latitude: latitude, longitude: longitude, image: image, status: status, callback: { result in
            
            switch result {
            case .success( _):
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
    func delete(id: Int) {
        // State -> Waiting
        self.handleWaiting()
        
        ApartmentAPIService.instance.delete(id: id, callback: { result in
            switch result {
            case .success( _):
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
}
