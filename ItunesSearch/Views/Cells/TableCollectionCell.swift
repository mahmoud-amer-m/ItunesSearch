//
//  TableCollectionCell.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/2/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit
import SDWebImage

class TableCollectionCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var searchResult: SearchBaseModel? {
        didSet {
            collectionCell.reloadData()
        }
    }
    var cellIdentifier: String = "ImageCell"
    var listingStyle: listingStyle = .grid
    var navigateToItem: ((Results) -> Void)?
    
    @IBOutlet weak var collectionCell: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    fileprivate var cellWidth: CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionCell.delegate = self
        collectionCell.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension TableCollectionCell {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return searchResult?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch listingStyle {
        case .grid:
            return CGSize(width: (collectionCell.frame.width / 3) - 8, height: 116)
        case .list:
            return CGSize(width: collectionCell.frame.width - 8, height: 116)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! ImageCollectionViewCell
        if let result = searchResult?.results?[indexPath.item] {
            if let desc = result.trackCensoredName {
                cell.descriptionLabel.text = desc
            }
            
            if listingStyle == .list {
                if let trackName = result.trackName {
                    cell.artistLabel.text = trackName
                }
            }
            cell.cellImageView.sd_setImage(with: URL(string: result.artworkUrl30 ?? ""), placeholderImage: UIImage(named: "deliveryIcon"), options: .refreshCached, completed: nil)
            collectionHeightConstraint.constant = collectionView.contentSize.height
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let result = searchResult?.results?[indexPath.item] {
            navigateToItem?(result)
        }
    }
}
