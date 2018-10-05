//
//  ViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/1/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var selectedEntities: [String] = []
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchTexhField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = DynamicSizeUICollectionViewFlowLayout()
        layout.Direction = .vertical
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        collectionView.collectionViewLayout = layout
    }

    @IBAction func showEntities(_ sender: UIButton) {
        let entitiesController: EntitiesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EntitiesViewController") as! EntitiesViewController
        entitiesController.setEntities = { [weak self] entities in
            print(entities)
            self?.selectedEntities = entities
            self?.collectionView.reloadData()
        }
        if (selectedEntities.count > 0) {
            entitiesController.selectedEntities = self.selectedEntities
            entitiesController.reloadEntities()
        }
        navigationController?.pushViewController(entitiesController, animated: true)
    }
    
    @IBAction func searchiTuens(_ sender: UIButton) {
        if let keyword = searchTexhField.text,
            keyword.count > 0,
            selectedEntities.count > 0 {
            let resultsController: ResultsViewController = UIStoryboard(name: "Main",
                                                                        bundle: nil).instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            resultsController.search(entities: selectedEntities, keyword: keyword)
            navigationController?.pushViewController(resultsController, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (selectedEntities[indexPath.item] as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize:20)])

        return CGSize(width: size.width, height: size.height + 4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return selectedEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entitiesIdCell",
                                                      for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor(red: 28/255, green: 135/255, blue: 212/255, alpha: 1)
        cell.cellLabel.text = selectedEntities[indexPath.item]
        return cell
    }
}
