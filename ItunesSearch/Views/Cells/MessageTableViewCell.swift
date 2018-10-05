//
//  MessageTableViewCell.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/5/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    var messageText: String? {
        didSet {
            messageLabel.text = messageText
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
