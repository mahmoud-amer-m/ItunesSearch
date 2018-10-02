//
//  EntitiesViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/2/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit

class EntitiesViewController: UITableViewController {
    let entities: [String] = ["Album", "Artist", "Book", "Movie", "Music", "musicVideo", "Video", "Podcast", "Song"]
    var selectedEntities: [String] = []
    var setEntities: (([String]) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "iTunesLogo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        navigationItem.titleView = imageView
    }
    
    func reloadEntities() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = entities[indexPath.row]
        cell.accessoryType = selectedEntities.contains(entities[indexPath.row]) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedEntities.contains(entities[indexPath.row]) {
            selectedEntities = selectedEntities.filter { $0 != entities[indexPath.row] }
        } else {
            selectedEntities.append(entities[indexPath.row])
        }
        setEntities?(selectedEntities)
        tableView.reloadData()
    }
}
