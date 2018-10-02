//
//  ResultsViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/2/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit

class ResultsViewController: BaseViewController {
    var baseModel = [[String: SearchBaseModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addItunesLogoToNavigation()
    }
    
    func reloadResults(model: [[String: SearchBaseModel]]) {
        baseModel = model
        print("model : \(baseModel)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
