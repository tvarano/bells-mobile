//
//  ClassTable.swift
//  bells
//
//  Created by Thomas Varano on 10/31/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation
import UIKit

struct CellData {
    let cell: Int!
    let className: String!
    let timeStr: String!
}


class ClassTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    init(with rotation: Rotation) {
       super.init()
        self.currentRotation = rotation
        loadPeriods()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ident", for: indexPath) as! ClassTableViewCell
        
        // cell not initializing properly
        
        initializeCell(cell: cell)
        cell.setData(c: data[indexPath.row])
        
        return cell
    }
    
    private func initializeCell(cell: ClassTableViewCell) {
        let insets = cell.safeAreaInsets
        cell.classPeriod = UILabel(frame: CGRect(x: insets.left, y: insets.top, width: (cell.frame.width - (insets.left + insets.right))/2, height: cell.frame.height - (insets.top + insets.bottom)))
        cell.time = UILabel(frame: CGRect(x: insets.left + cell.frame.width / 2, y: insets.top, width: (cell.frame.width - (insets.left + insets.right))/2, height: cell.frame.height - (insets.top + insets.bottom)))
        cell.addSubview(cell.classPeriod)
        cell.addSubview(cell.time)
    }
    
    var data = [CellData]()
    var currentRotation: Rotation?
    
    func loadPeriods() {
        var i = 0
        data.removeAll()
        if let rot = currentRotation {
            for p in rot.times {
                data.append(CellData(cell: i, className: p.name, timeStr: p.lengthString()))
                i+=1
            }
        }
    }
}
