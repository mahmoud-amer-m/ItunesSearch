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
    var selectedEntities: [String]?
    var keyword: String?  // Search keyword from home screen
    
    var results: NSMutableArray? // Search results Array
    var errorsArray: NSMutableArray? // Errors Array
    
    var viewState = Dynamic(ViewState.loading)
    var listingStyle: listingStyle = .grid
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iTuens Header Logo
        addItunesLogoToNavigation()
        //Tableview cell height, content inset
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        
        //Viewstate that controls the screen
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
        tableView.delegate = self
        tableView.dataSource = self
        search()
        super.viewWillAppear(animated)
    }
    
    func search() {
        guard let categories: [String] = selectedEntities else {return}
        guard categories.count > 0 else {return}
        let searchGroup = DispatchGroup()
        results = NSMutableArray()
        errorsArray = NSMutableArray()
        
        for (index, entity) in categories.enumerated() {
            searchGroup.enter()
            let parameters: [String: Any] = ["term": keyword ?? "", "entity" : entity]
            ServicesManager.searchAPI(entity: entity, parameters: parameters, completion: { (searchModel) in
                self.results?.add(["index" : index, "searchModel": searchModel])
                searchGroup.leave()
            }) { (error) in
                self.errorsArray?.add(["index" : index, "error": error])
                searchGroup.leave()
            }
        }
        searchGroup.notify(queue: .main) {
            if let searchResults = self.results,
                searchResults.count > 0 {
                self.viewState.value = .finishedLoadingSuccessfully(results: searchResults)
            } else {
                self.hideLoadingView()
                self.showAlert(title: "error", message: "Empty Results", buttonTitle: "Try Again", action: { _ in
                    self.showLoading()
                    self.search()
                })
            }
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
        return selectedEntities?[section] ?? ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedEntities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: - History Table View Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let sectionResults: [[String : Any]] = results as? [[String : Any]],
            let result = sectionResults.filter( { ($0["index"] as! Int) == indexPath.section } ).first {
            return constructCellWith(tableView: tableView, at: indexPath, resultArray: result["searchModel"] as? SearchBaseModel)
        } else {
            if let errors: [[String : Any]] = errorsArray as? [[String : Any]],
                let error: [String : Any] = errors.filter( { ($0["index"] as! Int) == indexPath.section } ).first {
                return constructEmptyCell(tableView: tableView, at: indexPath, message: (error["error"] as? String) ?? "")
            } else {
                return constructEmptyCell(tableView: tableView, at: indexPath, message: "Empty Results")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func constructCellWith(tableView: UITableView, at  indexPath: IndexPath, resultArray: SearchBaseModel?) -> UITableViewCell {
        guard let result = resultArray else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCollectionCell", for: indexPath) as! TableCollectionCell
        cell.searchResult = result
        
        switch listingStyle {
        case .grid:
            cell.cellIdentifier = "ImageCell"
        case .list:
            cell.cellIdentifier = "ListImageCell"
        }
        cell.listingStyle = listingStyle
        cell.navigateToItem = { [weak self] (result) in
            let detailsVC = UIStoryboard(name: UIConstants.storyBoard, bundle: nil).instantiateViewController(withIdentifier: "ItemDetailsViewController") as! ItemDetailsViewController
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
