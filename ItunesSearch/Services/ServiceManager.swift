//
//  ServiceManager.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/1/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import Reachability

class ServicesManager {
    
    public static func searchAPI(entity: String, searchKeywork: String, completion: @escaping (SearchBaseModel)->(), error: @escaping (String)->()) {
        
        let reachability = Reachability()
        if reachability?.connection == .none ||  reachability?.connection.description == "No Connection"{
            
        } else {
            var url: String = "\(APIConstants.baseSearchURL.rawValue)term=\(searchKeywork)&entity=\(entity)"
            url = url.replacingOccurrences(of: " ", with: "+")
            print("url : \(url)")
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    //First, check for request error
                    if let requestError = response.error {
                        error(requestError.localizedDescription)
                        return
                    }
                    
                    if let data = response.data, let _ = String(data: data, encoding: .utf8) {
                        if let baseModel = try? JSONDecoder().decode(SearchBaseModel.self, from: data) {
                            completion(baseModel)
                        } else {
                            //Json Error
                            error(DeliveryError.jsonError.rawValue)
                        }
                    } else {
                        //No response from server
                        error(DeliveryError.noResponseError.rawValue)
                    }
            }
        }
    }
}


