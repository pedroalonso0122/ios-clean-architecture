//
//  Networking.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/28.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
enum Result<Data: Decodable> {
    case success(Data)
    case failure(String)
}

typealias Handler = (Result<Data>) -> Void

protocol Requestable {}

extension Requestable {
    // Login & Register API. No Token
    internal func authRequest(url: String, params: Parameters?, callback: @escaping Handler) {
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in

            switch response.response?.statusCode {
            case 200:
                callback(.success(response.data!))
                break
            case 400:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 401:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 500:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            default:
                callback(.failure("Unexpected Error"))
                break;
            }
        }
    }
    
    // General API.Set Token
    internal func request(method: HTTPMethod, url: String, params: Parameters?, callback: @escaping Handler) {
        if !AuthManager.shared.hasValidToken {
            callback(.failure("Token Invalid Error"))
            return;
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer " + AuthManager.shared.token!
        ]
               
        AF.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in

            switch response.response?.statusCode {
            case 200:
                callback(.success(response.data!))
                break
            case 400:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 401:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 500:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            default:
                callback(.failure("Unexpected Error"))
                break;
            }
        }
    }
    
    internal func request(method: HTTPMethod, url: String, imgData: Data, parameters: Parameters, callback: @escaping Handler) {
        if !AuthManager.shared.hasValidToken {
            callback(.failure("Token Invalid Error"))
            return;
        }

        let headers: HTTPHeaders = [
            "Authorization" : "Bearer " + AuthManager.shared.token!
        ]
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "image.png", mimeType: "image/png")
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Float {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Double {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
        }, to: url, method: method, headers: headers).responseJSON {
            response in

            switch response.response?.statusCode {
            case 200:
                callback(.success(response.data!))
                break
            case 400:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 401:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 500:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            default:
                callback(.failure("Unexpected Error"))
                break;
            }
        }        
    }
}

