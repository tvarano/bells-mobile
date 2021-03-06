//
//  BackControllerVC.swift
//  bells
//
//  Created by Thomas Varano on 10/24/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation
import UIKit

class BackTableVC: UITableViewController {
    
    var rotations: RotationManager!
    var tableManager: RotationTableManager!
    var selectedRotation: Rotation?
    
    override func viewDidLoad() {
        tableManager = RotationTableManager(manager: rotations)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = tableManager.groups[indexPath.section].vals[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableManager.groups[section].vals.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableManager.groups.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableManager.groups[section].name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARING FOR SEGUE")
        
        if let selectedCell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: selectedCell)!
            let selectedItem = tableManager.groups[indexPath.section].vals[indexPath.row]
            selectedRotation = selectedItem
        }
    }
    
    
}
