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
    case baseSearchURL = "https://itunes.apple.com/search"
}

public class UIConstants {
    public static let storyBoard: String = "Main"
}

enum ErrorsConstants: String {
    case networkError = "No internet connection"
    case jsonError = "Sorry, Something went wrong :("
    case noResponseError = "No results found for your search %@ in %@"
    case missingEnterdDataMessage = "Please write search text and select at least one category"
    case missingEnterdDataTitle = "Missing Data"
}
