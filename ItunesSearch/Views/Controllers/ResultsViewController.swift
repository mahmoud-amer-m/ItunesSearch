//
//  ResultsViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/2/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit

enum ViewState {
    case loading
    case finishedLoadingWithError(error: String)
    case finishedLoadingSuccessfully(results: NSMutableArray)
    case finishedLoadingEmptyResults
}

enum listingStyle {
    case grid
    case list
}

class ResultsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedEntities: [String] = []
    var results: NSMutableArray?
    var errorsArray: NSMutableArray?
    var keyword: String?
    var viewState = Dynamic(ViewState.loading)
    var listingStyle: listingStyle = .grid
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItunesLogoToNavigation()
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        viewState.bind {[weak self] (state) in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self?.showLoading()
                case .finishedLoadingWithError(let error):
                    print(error)
                    self?.hideLoadingView()
                case .finishedLoadingSuccessfully(let baseModel):
                    self?.results = baseModel
                    self?.hideLoadingView()
                    self?.tableView.reloadData()
                case .finishedLoadingEmptyResults:
                    print("empty results!!")
                }
            }
        }
        viewState.value = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func search(entities: [String], keyword: String) {
        selectedEntities = entities
        self.keyword = keyword
        
        let downloadGroup = DispatchGroup()
        let _ = DispatchQueue.global(qos: .userInitiated)

        let queue = DispatchQueue(label: "myQueue", qos: .userInteractive, attributes: .concurrent)
        queue.async {
            DispatchQueue.concurrentPerform(iterations: self.selectedEntities.count) {
                index in
                self.results = NSMutableArray()
                self.errorsArray = NSMutableArray()
                downloadGroup.enter()
                let entity = entities[index]
                let parameters: [String: Any] = ["term": keyword, "entity" : entity]
                ServicesManager.searchAPI(entity: entity, parameters: parameters, completion: { (searchModel) in
                    self.results?.add(searchModel)
                    downloadGroup.leave()
                }) { (error) in
                    self.errorsArray?.add(error)
                    downloadGroup.leave()
                }
                downloadGroup.notify(queue: DispatchQueue.main) {
                    if let searchResults = self.results,
                        searchResults.count > 0 {
                        self.viewState.value = .finishedLoadingSuccessfully(results: searchResults)
                    } else {
                        DispatchQueue.main.async {
                            self.hideLoadingView()
                            self.showAlert(title: "erro", message: "Empty Results", buttonTitle: "Try Again", action: { _ in
                                self.search(entities: self.selectedEntities, keyword: self.keyword ?? "")
                            })
                        }
                    }
                    
                }
            }
        }
        DispatchQueue.concurrentPerform(iterations: selectedEntities.count) { index in
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func listTypeChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listingStyle = .grid
        case 1:
            listingStyle = .list
        default:
            listingStyle = .list
        }
        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated:true)
    }
}

extension ResultsViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedEntities[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedEntities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: - History Table View Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let count = results?.count,
            count > indexPath.section,
            let sectionResults = results?[indexPath.section] as? SearchBaseModel {
            return constructCellWith(tableView: tableView, at: indexPath, resultArray: sectionResults)
        } else {
            if let errors = errorsArray,
                errors.count > indexPath.section,
                let error: String = errors[indexPath.section] as? String {
                return constructEmptyCell(tableView: tableView, at: indexPath, message: error)
            } else {
                return constructEmptyCell(tableView: tableView, at: indexPath, message: "Empty Results")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func constructCellWith(tableView: UITableView, at  indexPath: IndexPath, resultArray: SearchBaseModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCollectionCell", for: indexPath) as! TableCollectionCell
        cell.searchResult = resultArray
        
        switch listingStyle {
        case .grid:
            cell.cellIdentifier = "ImageCell"
        case .list:
            cell.cellIdentifier = "ListImageCell"
        }
        cell.listingStyle = listingStyle
        cell.navigateToItem = { [weak self] (result) in
            let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailsViewController") as! ItemDetailsViewController
            detailsVC.result = result
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func constructEmptyCell(tableView: UITableView, at  indexPath: IndexPath, message: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        cell.messageText = message
        return cell
    }
}
