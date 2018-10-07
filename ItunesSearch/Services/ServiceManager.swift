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
    
    public static func searchAPI(parameters: [String: Any], completion: @escaping (SearchBaseModel)->(), apiError: @escaping (String)->()) {
        
        let reachability = Reachability()
        if reachability?.connection == .none ||  reachability?.connection.description == "No Connection"{
            apiError(ErrorsConstants.networkError.rawValue)
        } else {
            
            Alamofire.request(APIConstants.baseSearchURL.rawValue, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: [:])
                .responseData { response in
                    if let requestError = response.error {
                        apiError(requestError.localizedDescription)
                        return
                    }
                    guard let jsonData = response.value else {
                        return
                    }
                    do {
                        let baseModel = try JSONDecoder().decode(SearchBaseModel.self, from: jsonData)
                        guard let results = baseModel.results,
                            !results.isEmpty else {
                                apiError(String.init(format: ErrorsConstants.noResponseError.rawValue, arguments: [(parameters["term"] as? CVarArg) ?? "", (parameters["entity"] as? CVarArg) ?? ""]))
                                return
                        }
                        completion(baseModel)
                    } catch {
                        apiError(error.localizedDescription)
                    }
                }
        }
    }
}


