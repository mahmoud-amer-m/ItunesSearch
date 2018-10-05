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
    
    public static func searchAPI(entity: String, parameters: [String: Any], completion: @escaping (SearchBaseModel)->(), error: @escaping (String)->()) {
        
        let reachability = Reachability()
        if reachability?.connection == .none ||  reachability?.connection.description == "No Connection"{
            error(APIError.networkError.rawValue)
        } else {
            
            Alamofire.request(APIConstants.baseSearchURL.rawValue, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: [:])
                .responseData { response in
                    if let requestError = response.error {
                        error(requestError.localizedDescription)
                        return
                    }
                    guard let jsonData = response.value else {
                        return
                    }
                    if let baseModel = try? JSONDecoder().decode(SearchBaseModel.self, from: jsonData),
                        let results = baseModel.results,
                        !results.isEmpty{
                        completion(baseModel)
                    } else {
                        //Json Error
                        error(APIError.jsonError.rawValue)
                    }
                }
        }
    }
}


