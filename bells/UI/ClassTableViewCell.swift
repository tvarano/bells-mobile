//
//  ClassCellTableViewCell.swift
//  bells
//
//  Created by Thomas Varano on 10/31/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    var time: UILabel!
    var classPeriod: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("UM CHASDNAPSNOIDNU \(classPeriod)")
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//        self.backgroundColor = UIColor.blue
//    }
    
    func setData(c: CellData) {
        time.text = c.timeStr
        classPeriod.text = c.className
    }
    
}
