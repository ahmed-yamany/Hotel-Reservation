//
//  RoomTypeTableViewController.swift
//  HotelManzanaRebuild
//
//  Created by Ahmed Yamany on 31/07/2022.
//

import UIKit

class RoomTypeTableViewController: UITableViewController {
    
    var delegate: RoomTypeTableViewControllerDelegate?
    var roomType: RoomType?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RoomType.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        // roomType at indexPath
        let roomType = RoomType.all[indexPath.row]
    
        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        content.text = roomType.name
        content.secondaryText = "$\(roomType.price)"
        if self.roomType == roomType{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomType = RoomType.all[indexPath.row]
        
        self.roomType = roomType
        self.delegate?.roomTypeTableViewController(controller: self, roomType: roomType)
        tableView.reloadData()
    }
    
    
}
