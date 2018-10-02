//
//  Constants.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 9/14/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import Foundation
import UIKit

public enum APIConstants: String {
    case baseSearchURL = "https://itunes.apple.com/search?"
}

public class UIConstants {
    public static var tableViewCellEstimatedHeight: CGFloat = 50
}

enum DeliveryError: String {
    case networkError = "No internet connection"
    case jsonError = "Error decoding json"
    case noResponseError = "No response from server"
}
