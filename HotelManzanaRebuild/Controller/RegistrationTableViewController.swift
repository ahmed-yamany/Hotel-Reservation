//
//  RegistrationTableViewController.swift
//  HotelManzanaRebuild
//
//  Created by Ahmed Yamany on 31/07/2022.
//

import UIKit

protocol AddGuistRegistrationTableViewControllerDelegate{
    func addGuistRegistrationTableViewController(controller: AddGuistRegistrationTableViewController, registration: Registration)
    func deselectTabelRow()
}

class RegistrationTableViewController: UITableViewController {
    
    let saveLoadToFile = Registrations()
    
    // tableview registrations
    var registrations: [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plist = saveLoadToFile.loadFromFile()
        if let plist = plist {
            registrations += plist
        }

    }
    
    // MARK: - add Or edit registration
    @IBSegueAction func addEditRegistration(_ coder: NSCoder, sender: Any?) -> AddGuistRegistrationTableViewController? {
        // if sender is a cell
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
            // registration of cell indexPath
            let registration = registrations[indexPath.row]
            // new guistRegistration object with registrations
//            let obj = AddGuistRegistrationTableViewController(coder: coder)
            let obj = AddGuistRegistrationTableViewController(coder: coder)
            
            obj!.registration = registration
            obj!.delegate = self
            
            return obj
        }else{
            // else registration nil
            let obj = AddGuistRegistrationTableViewController(coder: coder)
            obj!.delegate = self
            return obj
    
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registrations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        content.text = "\(registration.firstName) \(registration.lastName)"
        
        content.secondaryText = "\((registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted)): \(registration.roomType.name)"
        
        cell.contentConfiguration = content

        return cell
    }
    

    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            registrations.remove(at: indexPath.row)
            saveLoadToFile.saveTofile(registrations: registrations)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}

extension RegistrationTableViewController: AddGuistRegistrationTableViewControllerDelegate{
    func addGuistRegistrationTableViewController(controller: AddGuistRegistrationTableViewController, registration: Registration) {
        
        if let selectedIndex = tableView.indexPathForSelectedRow{
            registrations[selectedIndex.row] = registration
            tableView.reloadRows(at: [selectedIndex], with: .none)
            tableView.deselectRow(at: selectedIndex, animated: true)
        }else{
            let newIndexPath = IndexPath(row: registrations.count, section: 0)
            registrations.append(registration)
            tableView.insertRows(at: [newIndexPath], with: .automatic)

        }
        
        saveLoadToFile.saveTofile(registrations: registrations)
        
    }
    
    func deselectTabelRow(){
        if let selectedIndex = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: selectedIndex, animated: true)

        }
    }
    
}
