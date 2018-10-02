//
//  ViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/1/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum ViewState {
    case none
    case finishedLoadingWithError(error: String)
    case loading
    case finishedLoadingSuccessfully(baseModel: [[String: SearchBaseModel]])
}

class ViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var viewState = Dynamic(ViewState.none)
    var baseSearchModel = [[String: SearchBaseModel]]()
    var selectedEntities: [String] = []
    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchTexhField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItunesLogoToNavigation()
        viewState.bind {[weak self] (state) in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self?.showLoading()
                case .finishedLoadingWithError(let error):
                    self?.hideLoadingView()
                case .finishedLoadingSuccessfully(let baseModel):
                    self?.hideLoadingView()
                    self?.goToResults()
                case .none:
                    print("none")
                }
            }
        }
        
        let layout = DynamicSizeUICollectionViewFlowLayout()
        layout.Direction = .vertical
        collectionView.collectionViewLayout = layout
    }
    
    func goToResults() {
        let resultsController: ResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        resultsController.reloadResults(model: baseSearchModel)
        navigationController?.pushViewController(resultsController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let searchText = searchTexhField.text, searchText.count > 0, selectedEntities.count > 0 {
            viewState.value = .loading
            
            selectedEntities.forEach { (entity) in
                dispatchGroup.enter()
                ServicesManager.searchAPI(entity: entity, searchKeywork: searchText, completion: { [weak self] (searchModel) in
                    self?.baseSearchModel.append([entity: searchModel])
                    self?.dispatchGroup.leave()
                }) { (error) in
                    self.dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main) { [weak self] in
                    self?.hideLoadingView()
                    if let results = self?.baseSearchModel {
                        self?.viewState.value = .finishedLoadingSuccessfully(baseModel: results)
                    }
                    
                    print("Both functions complete 👍")
                }

            }
        }
    }
    
    
    
}

// MARK: - UICollectionViewDataSource
extension ViewController {
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return selectedEntities.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entitiesIdCell",
                                                      for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor(red: 28/255, green: 135/255, blue: 212/255, alpha: 1)
        cell.cellLabel.text = selectedEntities[indexPath.item]
        // Configure the cell
        return cell
    }
}


