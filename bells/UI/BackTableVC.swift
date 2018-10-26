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
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        tableArray = ["R1", "Odd Block", "Even Block", "R4", "R3",
                      /*BREAK*/ "", "R1 Half Day", "R3 Half Day", "R4 Half Day", "R1 Delayed Open"]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    // change information to the main VC after segue back.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destNav = segue.destination as! UINavigationController
        let destVC = destNav.viewControllers[0] as! ViewController
        let indexPath: NSIndexPath = self.tableView!.indexPathForSelectedRow! as NSIndexPath
        destVC.varView = tableArray[indexPath.row]

    }
    
    
}
