//
//  ViewController.swift
//  bells
//
//  Created by Thomas Varano on 10/23/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//


import UIKit

var firstLoad = true

class ViewController: UIViewController {
    
    @IBOutlet weak var tableBackground: UIView!
    
    @IBOutlet weak var classTable: UITableView!
    var timer: Timer!
    
    // have the ability to reread in settings
    var rotations: RotationManager!
    var timeManager: TimeManager!
    var delegate: ClassTableViewDelegate!
    

    @IBOutlet weak var open: UIBarButtonItem!
    var changedRotation: Rotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if firstLoad {
            print("initial setting")
            initialSetting()
            firstLoad = false
        }
        
        /*
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector(("respondToSwipeGesture:")))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
         */

        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
        otherInit()
        updateUI()
    }
    
    /*
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped right")
                //change view controllers
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "rotationSet") as! BackTableVC
                
                self.present(resultViewController, animated:true, completion:nil)

            default:
                break
            }
        }
    }
     */
    
    private func otherInit() {
        if (timeManager == nil) {
            timeManager = TimeManager(rotations: rotations, view: self)
        }
        updateRotation()
        updateUI()
    }
    
    private func createTable() {
        // delete all data
        if let oldDel = classTable.delegate {
            let oldCastDel = oldDel as! ClassTableViewDelegate
            oldCastDel.data.removeAll()
        }
        if classTable.delegate == nil {
            delegate = ClassTableViewDelegate(with: timeManager.currentRotation)
            classTable.register(ClassTableViewCell.self, forCellReuseIdentifier: "ident")
            classTable.dataSource = delegate
            classTable.delegate = delegate
        } else {
            let delegate = classTable.delegate as! ClassTableViewDelegate
            delegate.currentRotation = timeManager.currentRotation
            delegate.loadPeriods()
            classTable.reloadData()
        }
}
    
    func initialSetting() {
        rotations = RotationManager()
        if timeManager == nil {
            timeManager = TimeManager(rotations: rotations, view: self)
        }
    }
    
    func update() {
        updateRotation()
        updateUI()
    }
    
    func updateRotation() {
        var changed = false
        if changedRotation == nil {
            changedRotation = timeManager.currentRotation
            changed = true
        }
        if !changedRotation.equals(other: timeManager.currentRotation) {
            timeManager.currentRotation = rotations.get(name: changedRotation.name)!
            changed = true
        }
        if changed {
            createTable()
            state = 4
        }
    }
    
    private var state: Int = 0
    
    func updateUI() {
        setRotationLabel(to: timeManager.currentRotation.name)
        // set current class
        if let current = timeManager.getCurrentClass() {
            // if in class, state is 0
            setNormalLabels(current: current)
        } else {
            // not directly in class
            if timeManager.currentRotation.day().contains(time: Time.now()) {
                // in between classes, state is 1
                setBetweenLabels()
            } else {
                // out of school, state 2
                setOutOfSchoolLabels()
            }
        }
    }
    
    @IBOutlet weak var rotationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentClassLabel: UILabel!
    @IBOutlet weak var lowerContentLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    private func setNormalLabels(current: Period) {
        if state != 0 {
            statusLabel.isHidden = false
            statusLabel.text = "You are in"
            currentClassLabel.font = currentClassLabel.font.withSize(34)
            lowerContentLabel.font = lowerContentLabel.font.withSize(17)
            lowerContentLabel.text = "for"
            state = 0
        }
        currentClassLabel.text = current.name
        timeLeftLabel.text = current.remaining()
    }
    
    private func setOutOfSchoolLabels() {
        if state != 2 {
            statusLabel.isHidden = true
            currentClassLabel.font = currentClassLabel.font.withSize(28)
           currentClassLabel.text = "You are not in school."
            lowerContentLabel.font = lowerContentLabel.font.withSize(25)
            lowerContentLabel.text = "School is in"
            state = 2
        }
        // NOTE change this so its for tomorrows
        print(Time.now())
        timeLeftLabel.text = Time.now().timeUntil(other: timeManager.currentRotation.day().startTime).remainString()
    }
    
    private func setBetweenLabels() {
        let next = timeManager.findNextClass()!
        if state != 1 {
            statusLabel.isHidden = false
            statusLabel.text = "You are between classes"
            currentClassLabel.font = currentClassLabel.font.withSize(34)
            lowerContentLabel.font = lowerContentLabel.font.withSize(17)
            lowerContentLabel.text = "is in"
            currentClassLabel.text = next.name
            state = 1
        }
        timeLeftLabel.text = Time.now().timeUntil(other: next.startTime).remainString()
    }
    
    func setRotationLabel(to name: String) {
        rotationLabel.text = name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //stop timer
        timer.invalidate()
        
        if let destNav = segue.destination as? BackTableVC {
            print("prepare and pass rotation")
            destNav.rotations = self.rotations
        }
        
    }
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        print("set the rotation to unwind")
        let srcViewCon = sender.source as? BackTableVC
        let rot = srcViewCon?.selectedRotation
        
        if  (srcViewCon != nil && rot?.name != "") {
            // change the rotation
            changedRotation = rot
            update()
        }
    }
    
    @IBAction func cancel(sender: UIStoryboardSegue) {
        print("exit with cancel")
    }
    

    @objc func fireTimer() {
        updateUI()
    }
    
}
