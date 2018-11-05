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

var firstLoad = true

class ViewController: UIViewController {
    
    @IBOutlet weak var rotationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentClassLabel: UILabel!
    @IBOutlet weak var lowerContentLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var tableBackground: UIView!
    
    @IBOutlet weak var classTable: UITableView!
    
    // have the ability to reread in settings
    var rotations: RotationManager!
    var timeManager: TimeManager!
    var delegate: ClassTableViewDelegate!
    

    @IBOutlet weak var open: UIBarButtonItem!
    var changedRotation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if firstLoad {
            print("initial setting")
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
        updateRotation()
        updateUI()
    }
    
    private func createTable() {
        delegate = ClassTableViewDelegate(with: timeManager.currentRotation)
        classTable.register(ClassTableViewCell.self, forCellReuseIdentifier: "ident")
        classTable.dataSource = delegate
        classTable.delegate = delegate
    }
    
    func initialSetting() {
        rotations = RotationManager()
        if timeManager == nil {
            timeManager = TimeManager(rotations: rotations, view: self)
        }
        changedRotation = timeManager.currentRotation.name
    }
    
    func updateRotation() {
        if changedRotation == "" {
            changedRotation = timeManager.currentRotation.name
        }
        if changedRotation != timeManager.currentRotation.name {
            timeManager.currentRotation = rotations.get(name: changedRotation)!
            updateTodayClasses()
        }
        createTable()
    }
    
    func updateUI() {
        updateRotation()
        setRotationLabel(to: timeManager.currentRotation.name
        )
        // set current class
        if let current = timeManager.getCurrentClass() {
            // if in class
            currentClassLabel.text = current.name
            timeLeftLabel.text = current.remaining()
        } else {
            // not directly in class
            currentClassLabel.text = Time.now().string()
        }
    }
    
    func updateTodayClasses() {
        
    }
    
    func setRotationLabel(to name: String) {
        rotationLabel.text = name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destNav = segue.destination as? BackTableVC {
            print("PASSING ROTATIONS")
            destNav.rotations = self.rotations
        }
        
    }
}
