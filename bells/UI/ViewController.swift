//
//  ViewController.swift
//  bells
//
//  Created by Thomas Varano on 10/23/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var open: UIBarButtonItem!
    var varView = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        label.text = varView
    }

    @IBOutlet weak var label: UILabel!
    
}

