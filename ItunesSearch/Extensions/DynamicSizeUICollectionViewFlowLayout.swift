//
//  DynamicSizeUICollectionViewFlowLayout.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/1/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import Foundation
import UIKit

class DynamicSizeUICollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        self.scrollDirection = .horizontal
    }

    var Direction: UICollectionViewScrollDirection {
        set {
            self.scrollDirection = newValue
        }

        get {
            return self.scrollDirection
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
