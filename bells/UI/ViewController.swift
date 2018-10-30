//
//  ViewController.swift
//  bells
//
//  Created by Thomas Varano on 10/23/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

/* NOTES
 - maybe discard the table view? its making you reinitialize everything, which isn't great.
 - have it by the navigation controller. keep custom transition to side, but try having it for the other thing
 
 */

// NOTE GIVE THE TABLE THE ROTATION MANAGER AND THEN GIVE IT BACK. DON'T INSTANTIATE EVERY TIME


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rotationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentClassLabel: UILabel!
    @IBOutlet weak var lowerContentLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    // have the ability to reread in settings
    var rotations: RotationManager!
    var timeManager: TimeManager!

    @IBOutlet weak var open: UIBarButtonItem!
    var changedRotation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if firstLoad {
            initialSetting()
            firstLoad = false
        }
        otherInit()
        updateUI()
    }
    
    private func otherInit() {
        if (timeManager == nil) {
            timeManager = TimeManager(rotations: rotations, view: self)
        }
        
        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        updateUI()
    }
    
    func initialSetting() {
        rotations = RotationManager()
        if timeManager == nil {
            timeManager = TimeManager(rotations: rotations, view: self)
        }
        changedRotation = timeManager.currentRotation.name
    }
    
    func updateUI() {
        if changedRotation == "" {
            changedRotation = timeManager.currentRotation.name
            
        }
        if changedRotation != timeManager.currentRotation.name {
            timeManager.currentRotation = rotations.get(name: changedRotation)!
        }
        setRotationLabel(to: timeManager.currentRotation.name
        )
        if timeManager.getCurrentClass() != nil {
            currentClassLabel.text = timeManager.getCurrentClass()?.name
        }
    }
    
    func setRotationLabel(to name: String) {
        rotationLabel.text = "Today's Rotation: "+name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare??")
        if let destNav = segue.destination as? BackTableVC {
            print("PASSING ROTATIONS")
            destNav.rotations = self.rotations
        }
        
        
    }
}

var firstLoad = true
