//
//  ItemDetailsViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/2/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ItemDetailsViewController: BaseViewController {
    var result: Results?
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var playVideoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addItunesLogoToNavigation()
        displayData()
    }
    
    func displayData() {
        descLabel.text = result?.trackName
        itemImageView.sd_setImage(with: URL(string: result?.artworkUrl100 ?? ""), placeholderImage: UIImage(named: "deliveryIcon"), options: .refreshCached, completed: nil)
        
        if (result?.previewUrl) != nil {
            playVideoButton.isHidden = false
            playVideo()
        } else {
            playVideoButton.isHidden = true
        }
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        playVideo()
    }
    
    func playVideo() {
        if let previewURL = result?.previewUrl {
            let videoURL = URL(string: previewURL)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}
