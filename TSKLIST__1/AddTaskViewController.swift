//
//  AddTaskViewController.swift
//  TSKLIST__1
//
//  Created by soniclouds on 3/15/17.
//  Copyright © 2017 soniclouds. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//MARK...................................VAR.................
    weak var addTaskDelegate: AddTaskDelegate?

    var types = ["work", "fun", "home", "family", "errands", "life events", "other"]
    var selectedType = String()
    var selectedPriority = Int16()
    var task: Task?
    var indexPath: NSIndexPath?
    
//MARK...................................FUNC................
    
    func changePriority(_ sender: UISlider) {
        selectedPriority = Int16(lround(Double(Int16(sender.value * 100))))
    }
    
    func changePriorityLabelColor(){
        var colorBasisBG = Float()
        if selectedPriority == 1 {
            colorBasisBG = 1.0
        } else if selectedPriority == 2 {
            colorBasisBG = 0.9
        } else if selectedPriority == 3 {
            colorBasisBG = 0.8
        } else if selectedPriority == 4 {
            colorBasisBG = 0.7
        } else if selectedPriority == 5 {
            colorBasisBG = 0.6
        } else if selectedPriority == 6 {
            colorBasisBG = 0.5
        } else if selectedPriority == 7 {
            colorBasisBG = 0.4
        } else if selectedPriority == 8 {
            colorBasisBG = 0.3
        } else if selectedPriority == 9 {
            colorBasisBG = 0.1
        } else if selectedPriority == 10 {
            colorBasisBG = 0.0
        }
        priorityLabel.textColor = UIColor(red: 1.0, green: CGFloat(colorBasisBG), blue: 0.0, alpha: 1.0)
    }
    
    
//MARK...................................TABLE VIEW METHODS..
    
    // Category Options Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        count = types.count
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var type = String()
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        type = types[indexPath.row]
        cell.typeNameLabel.text = type
        if type == "work" {
            cell.typeImage.image = #imageLiteral(resourceName: "work")
        } else if type == "fun" {
            cell.typeImage.image = #imageLiteral(resourceName: "fun_1")
        } else if type == "home" {
            cell.typeImage.image = #imageLiteral(resourceName: "house_chores_1")
        } else if type == "family" {
            cell.typeImage.image = #imageLiteral(resourceName: "family_1")
        } else if type == "life events" {
            cell.typeImage.image = #imageLiteral(resourceName: "achievement_1")
        } else if type == "errands" {
            cell.typeImage.image = #imageLiteral(resourceName: "notepad_1")
        } else {
            cell.typeImage.image = #imageLiteral(resourceName: "graph_1")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = types[indexPath.row]
        categoryTableView.isHidden = true
        categoryImageView.isHidden = false
        priorityLabel.isHidden = false
        if selectedType == "work" {
            categoryImageView.image = #imageLiteral(resourceName: "work")
        } else if selectedType == "fun" {
            categoryImageView.image = #imageLiteral(resourceName: "fun_1")
        } else if selectedType == "home" {
            categoryImageView.image = #imageLiteral(resourceName: "house_chores_1__small")
        } else if selectedType == "family" {
            categoryImageView.image = #imageLiteral(resourceName: "family_1")
        } else if selectedType == "life events" {
            categoryImageView.image = #imageLiteral(resourceName: "achievement_1")
        } else if selectedType == "errands" {
            categoryImageView.image = #imageLiteral(resourceName: "notepad_1")
        } else {
            categoryImageView.image = #imageLiteral(resourceName: "graph_1")
        }
    }

//MARK...................................OUT.................

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var detailsInput: UITextView!
    @IBOutlet weak var detailsPlaceholderButton: UIButton!
    
    @IBOutlet weak var dateInput: UIDatePicker!

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryOptions: UIView!
    
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var priorityLabel: UILabel!
    
//MARK...................................ACT.................
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        categoryTableView.isHidden = false
        categoryImageView.isHidden = true
        priorityLabel.isHidden = true
    }
    
    @IBAction func priorityButtonPressed(_ sender: UIButton) {
        prioritySlider.isHidden = false
        priorityButton.isHidden = true
    }
    @IBAction func prioritySlider(_ sender: UISlider) {
        changePriority(sender)
        if selectedPriority == 0 {
            priorityLabel.text = ""
        } else {
            priorityLabel.text = String(selectedPriority)
        }
        changePriorityLabelColor()
    }
    @IBAction func pSlidEnd(_ sender: UISlider) {
        print("pSlid touch up!")
        prioritySlider.isHidden = true
        priorityButton.isHidden = false
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIButton) {
        if titleInput.text != "" {
            let title = titleInput.text!
            if let details = detailsInput.text {
                let date = dateInput.date
                let type = selectedType
                let priority = selectedPriority
                addTaskDelegate?.itemSaved(by: self, with: title, with: details, with: type, with: priority, with: date as NSDate, at: indexPath)
            }
        } else {
            print("no title!")
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func detailsPlaceholderButtonPressed(_ sender: UIButton) {
        detailsPlaceholderButton.isHidden = true
        detailsInput.becomeFirstResponder()
    }
    
//MARK...................................UI LIFECYCLE.........

    override func viewDidLoad() {
        super.viewDidLoad()

        detailsPlaceholderButton.contentHorizontalAlignment = .left
        prioritySlider.setThumbImage(#imageLiteral(resourceName: "blue_circle__small"), for: .normal)
        
        titleInput.text = task?.title
        detailsInput.text = task?.details
        
        if task?.details != nil {
            detailsPlaceholderButton.isHidden = true
        }
        
        if task != nil {
            dateInput.date = task?.date as! Date
        }
        if task?.type != nil {
            selectedType = (task?.type)!
        } else {
            selectedType = "other"
        }
        if task?.priority != nil {
            selectedPriority = (task?.priority)!
            priorityLabel.text = String(selectedPriority)
            changePriorityLabelColor()
        } else {
            selectedPriority = 0
            priorityLabel.text = ""
        }
        if priorityLabel.text == "0" {
            priorityLabel.text = ""
        }
        
        prioritySlider.value = (Float(selectedPriority) / Float(100))
        if selectedType != nil {
            categoryImageView.isHidden = false
            if selectedType == "work" {
                categoryImageView.image = #imageLiteral(resourceName: "work")
            } else if selectedType == "fun" {
                categoryImageView.image = #imageLiteral(resourceName: "fun_1")
            } else if selectedType == "home" {
                categoryImageView.image = #imageLiteral(resourceName: "house_chores_1__small")
            } else if selectedType == "family" {
                categoryImageView.image = #imageLiteral(resourceName: "family_1")
            } else if selectedType == "life events" {
                categoryImageView.image = #imageLiteral(resourceName: "achievement_1")
            } else if selectedType == "errands" {
                categoryImageView.image = #imageLiteral(resourceName: "notepad_1")
            } else {
                categoryImageView.image = #imageLiteral(resourceName: "graph_1")
            }
        } else {
            if categoryImageView.isHidden == false {
                categoryImageView.isHidden = true
                categoryImageView.image = #imageLiteral(resourceName: "graph_1")
            }
        }
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
