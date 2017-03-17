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
        print("sender value: ", sender.value)
        print ("selectedPriority: ", selectedPriority)
        
    }
    
    func changePriorityLabelColor(){
        if selectedPriority > 0 && selectedPriority < 5 {
            priorityLabel.textColor = UIColor.yellow
        } else if selectedPriority > 4 && selectedPriority < 8 {
            priorityLabel.textColor = UIColor.orange
        } else if selectedPriority > 7 {
            priorityLabel.textColor = UIColor.red
        }
    }
    
    //MARK...................................TABLE VIEW METHODS..
    
    // Category Options Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        //        if tableView == self.categoryTableView {
        count = types.count
        //        }
        print(count!)
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        var cell: UITableViewCell?
        var type = String()
        //        if tableView == self.categoryTableView {
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
        
        //            print(types[indexPath.row])
        //            cell.backgroundColor = UIColor.cyan
        print(cell)
        return cell
        //
        //        } else {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        //            print("even though the output looks the same, this is the else condition in cellForRow...")
        //            return cell
        //        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = types[indexPath.row]
        categoryTableView.isHidden = true
        categoryImageView.isHidden = false
        //        categoryButton.titleLabel?.text = ""
        //
        //        categoryButton.titleLabel?.textAlignment = .center
        //        categoryButton.titleLabel?.textColor = UIColor.blue
        //        categoryButton.titleLabel?.text = selectedType
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
    @IBOutlet weak var dateInput: UIDatePicker!
    
    @IBOutlet weak var detailsPlaceholderButton: UIButton!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var categoryOptions: UIView!
    
    @IBOutlet weak var priorityButton: UIButton!
    
    @IBOutlet weak var prioritySlider: UISlider!
    
    @IBOutlet weak var priorityLabel: UILabel!
    
    //MARK...................................ACT.................
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        categoryTableView.isHidden = false
        categoryImageView.isHidden = true
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
        // capture values into constants, WHILE checking that they have input (if not, the function will break)
        if titleInput.text != "" {
            let title = titleInput.text!
            if let details = detailsInput.text {
                let date = dateInput.date
                print("checking date...: ", date)
                let type = selectedType
                
                let priority = selectedPriority
                //                addTaskDelegate?.itemSaved(by: self, with: title, with: details, with: type, with: priority, with: isComplete, with: time, with: date as NSDate)
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
        //        detailsPlaceholderButton.titleLabel!.textAlignment = .left
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
            print("no type selected!")
        }
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        //        categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
        //
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
