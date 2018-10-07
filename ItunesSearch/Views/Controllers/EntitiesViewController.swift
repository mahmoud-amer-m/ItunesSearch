//
//  EntitiesViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/2/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit

class EntitiesViewController: UITableViewController {
    var entities: [Entity] = [Entity(name: "All"), Entity(name: "Album"), Entity(name: "Artist"), Entity(name: "Book"), Entity(name: "Movie"), Entity(name: "Music"), Entity(name: "musicVideo"), Entity(name: "Video"), Entity(name: "Podcast"), Entity(name: "Song")]
    var setEntities: (([Entity]) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "iTunesLogo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        navigationItem.titleView = imageView
    }
    
    func reloadEntities(selectedEntities: [Entity]) {
        for (index, entity) in entities.enumerated() {
            if selectedEntities.filter({ $0.entityName == entity.entityName }).first != nil {
                entities[index].isSelected = true
            }
        }
        entities[0].isSelected = checkIfAllSelected()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let entity: Entity = entities[indexPath.row]
        cell.textLabel?.text = entity.entityName
        if indexPath.row == 0 {
            cell.accessoryType = checkIfAllSelected() ? .checkmark : .none
        } else {
            cell.accessoryType = entity.isSelected ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        entities[indexPath.row].isSelected = !entities[indexPath.row].isSelected
        if indexPath.row == 0
        {
            for (index, _) in entities.enumerated() {
                entities[index].isSelected = entities[indexPath.row].isSelected
            }
        }
        setEntities!(createEntitiesForRequest().filter({ $0.isSelected == true }))
        tableView.reloadData()
    }
    
    func createEntitiesForRequest() -> [Entity] {
        var returnArray: [Entity] = entities
        if entities.filter({ $0.entityName == "All" }).first != nil {
            returnArray.removeFirst()
        }
        return returnArray
    }
    
    func checkIfAllSelected() -> Bool {
        return !(entities.filter({ $0.entityName != "All" }).filter({ $0.isSelected == false }).count > 0)
    }
}



struct Entity
{
    var entityName:String
    var isSelected:Bool! = false
    init(name:String) {
        self.entityName = name
    }
}
