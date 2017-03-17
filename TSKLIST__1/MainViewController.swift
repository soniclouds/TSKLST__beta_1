//
//  MainViewController.swift
//  TSKLIST__1
//
//  Created by soniclouds on 3/15/17.
//  Copyright © 2017 soniclouds. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController, AddTaskDelegate {

//MARK...................................VAR..................
    var currentArray = [Task]()
    var tasks = [Task]()
    var tasksDateReverse = [Task]()
    var dateMode = Int()
    var completedTasks = [Task]()
    var concatArray = [Task]()
    var showSorted: Bool?
    var sortBy = String()
    // for priority: if 0, 0-10 ascending -- if 1, 10-0 descending -- if 2, reset
    var sortOrderPriority: Int?
    // for type: if 0... types ascending -- if 1, reverse -- if 2, reset // expand on this in version 2
    var sortOrderType: Int?
    
    var todayButtonOn: Bool?
    var tomorrowButtonOn: Bool?
    
    var selectedTask: Task?
    var selectedIndex = -1
    
    var taskID: String?
    
    var hide = true
    var state = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//MARK...................................FUNC.................
    
    func dateIsToday(date: Date) -> Bool {
        let testDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let dateComponents = (Calendar.current).dateComponents([.year, .month, .day, .weekday], from: date)
        let dateComponents2 = (Calendar.current).dateComponents([.year, .month, .day], from: testDate )
        
        let year = dateComponents.year
        let testYear = dateComponents2.year
        
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![dateComponents.month! - 1]
        let testMonthSymbol = months![dateComponents2.month! - 1]
        
        let day = dateComponents.day!
        let testDay = dateComponents2.day!
        
        if year == testYear && monthSymbol == testMonthSymbol && day == testDay {
            return true
        } else {
            return false
        }
    }
    func dateIsTomorrow(date: Date) -> Bool {
        let testDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        let dateComponents = (Calendar.current).dateComponents([.year, .month, .day, .weekday], from: date)
        let dateComponents2 = (Calendar.current).dateComponents([.year, .month, .day], from: testDate )
        
        let year = dateComponents.year
        let testYear = dateComponents2.year
        
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![dateComponents.month! - 1]
        let testMonthSymbol = months![dateComponents2.month! - 1]
        
        let day = dateComponents.day!
        let testDay = dateComponents2.day!
        
        if year == testYear && monthSymbol == testMonthSymbol && day == testDay + 1 {
            return true
        } else {
            return false
        }
    }
    
    func determineCurrentArray(){
        if showSorted == true {
            if sortBy == "complete" {
                if completedTasks.count > 0 {
                    if todayButtonOn == true {
                        let tempArray = concatAllTasks() as! [Task]
                        var resultArray = [Task]()
                        for tT in tempArray {
                            if dateIsToday(date: tT.date as! Date) == true {
                                resultArray.append(tT)
                            }
                        }
                        currentArray = resultArray
                    } else if tomorrowButtonOn == true {
                        let tempArray = concatAllTasks() as! [Task]
                        var resultArray = [Task]()
                        for tT in tempArray {
                            if dateIsTomorrow(date: tT.date as! Date) == true {
                                resultArray.append(tT)
                            }
                        }
                        currentArray = resultArray
                    } else {
                        currentArray = concatAllTasks() as! [Task]
                    }
                }
            } else if sortBy == "priority" {
                if todayButtonOn == true {
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray {
                        if dateIsToday(date: tT.date as! Date) == true {
                            resultArray.append(tT)
                        }
                    }
                    currentArray = resultArray
                } else if tomorrowButtonOn == true {
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray {
                        if dateIsTomorrow(date: tT.date as! Date) == true {
                            resultArray.append(tT)
                        }
                    }
                    currentArray = resultArray
                } else {
                    currentArray = concatAllTasks() as! [Task]
                }
            } else if sortBy == "type" {
                if todayButtonOn == true {
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray {
                        if dateIsToday(date: tT.date as! Date) == true {
                            resultArray.append(tT)
                        }
                    }
                    currentArray = resultArray
                } else if tomorrowButtonOn == true {
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray {
                        if dateIsTomorrow(date: tT.date as! Date) == true {
                            resultArray.append(tT)
                        }
                    }
                    currentArray = resultArray
                } else {
                    currentArray = concatAllTasks() as! [Task]
                }
            }
        } else {
            getAll()
            if todayButtonOn == true {
                var tempArray = [Task]()
                if dateMode == 0 {
                    tempArray = tasks
                } else {
                    tempArray = tasksDateReverse
                }
                var resultArray = [Task]()
                for tT in tempArray {
                    if dateIsToday(date: tT.date as! Date) == true {
                        resultArray.append(tT)
                    }
                }
                currentArray = resultArray
            }
            else if tomorrowButtonOn == true {
                var tempArray = [Task]()
                if dateMode == 0 {
                    tempArray = tasks
                } else {
                    tempArray = tasksDateReverse
                }
                var resultArray = [Task]()
                for tT in tempArray {
                    if dateIsTomorrow(date: tT.date as! Date) == true {
                        resultArray.append(tT)
                    }
                }
                currentArray = resultArray
            } else {
                if dateMode == 0 {
                    currentArray = tasks
                } else {
                    currentArray = tasksDateReverse
                }
            }
        }
    }
    func sortDates(initialArray: [Task]) -> [Task] {
        var sortedArray = [Task]()
        var check = initialArray[0].date as! Date
        for var i in 0..<initialArray.count {
            if (initialArray[i].date as! Date) < check {
                check = initialArray[i].date as! Date
            }
        }
        sortedArray.append(initialArray[0])
        for var j in 1..<initialArray.count {
            if (initialArray[j].date as! Date) >= ((sortedArray[j - 1]).date as! Date) {
                sortedArray.append(initialArray[j])
            } else {
                for var t in 0..<sortedArray.count {
                    if (initialArray[j].date as! Date) < (sortedArray[t].date as! Date) {
                        sortedArray.insert(initialArray[j], at: t)
                        break
                    } else {
                        print("good right here")
                    }
                }
            }
        }
        return sortedArray
    }
    func simpleReverseAppend(sortedArray: [Task]) -> [Task] {
        var reversedArray = [Task]()
        var dateRevIndex = sortedArray.count - 1
        while dateRevIndex >= 0 {
            reversedArray.append(sortedArray[dateRevIndex])
            dateRevIndex -= 1
        }
        return reversedArray
    }
    func getAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let result = try context.fetch(request)
            let initialTasks = result as! [Task]
            if initialTasks.count > 0 {
                tasks = sortDates(initialArray: initialTasks)
                tasksDateReverse = simpleReverseAppend(sortedArray: tasks)
            }
            for t in tasks {
                if t.isComplete == true {
                    completedTasks.append(t)
                }
            }
        } catch {
            print("\(error)")
        }
    }
    func concatAllTasks() -> Array<Any> {
        var leftoversArray = [Task]()
        var concArr = [Task]()

        if sortBy == "complete" {
            if completedTasks.count < tasks.count {
                for task in currentArray {
                    if task.isComplete == false {
                        leftoversArray.append(task)
                    }
                }
                concArr = completedTasks + leftoversArray
                return concArr
            } else {
                return completedTasks
            }
        } else if sortBy == "priority" {
            var start = Int()
            if sortOrderPriority == 2 {
                getAll()
                return tasks
            } else if sortOrderPriority == 0 {
                start = 0
                var priorityArray = [Task]()
                while start <= 10 {
                    for task in currentArray {
                        if task.priority == Int16(start) {
                            priorityArray.append(task)
                        }
                    }
                    start += 1
                }
                return priorityArray
            } else if sortOrderPriority == 1 {
                start = 10
                var priorityArray = [Task]()
                while start >= 0 {
                    for task in currentArray {
                        if task.priority == Int16(start) {
                            priorityArray.append(task)
                        }
                    }
                    start -= 1
                }
                return priorityArray
            }
        }
        else if sortBy == "type" {
            var types = ["work", "fun", "home", "family", "life events", "errands", "other"]
            var typeArray = [Task]()
            
            if sortOrderType == 2 {
                getAll()
                return tasks
            }
            if sortOrderType == 0 {
                var loopCount = 0
                while loopCount < (types.count) {
                    for task in currentArray {
                        if task.type == types[loopCount] {
                            typeArray.append(task)
                        }
                    }
                    loopCount += 1
                }
                return typeArray
            } else {
                var loopCount = types.count - 1
                while loopCount >= 0 {
                    for task in currentArray {
                        if task.type! == (types[loopCount]) {
                            typeArray.append(task)
                        }
                    }
                    loopCount -= 1
                }
                return typeArray
            }
        }
        return currentArray
    }
    func getTimeDate(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd yyyy - hh:m a"
        return dateFormatter.string(from: date as Date)
    }
    
    
//MARK...................................TABLE VIEW METHODS...
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        var task = Task()

        task = currentArray[indexPath.row]

        cell.task = task

        if let type = task.type {
            if type == "work" {
                cell.typeIconButton.setImage(#imageLiteral(resourceName: "work"), for: .normal)
            } else if type == "fun" {
                cell.typeIconButton.setImage(#imageLiteral(resourceName: "fun_1"), for: .normal)
            } else if type == "home" {
                cell.typeIconButton.setImage(#imageLiteral(resourceName: "house_chores_1"), for: .normal)
            } else if type == "family" {
                cell.typeIconButton.setImage(#imageLiteral(resourceName: "family_1"), for: .normal)
            } else if type == "errands" {
                cell.typeIconButton.setImage(#imageLiteral(resourceName: "notepad_1"), for: .normal)
            } else if type == "life events" {
                cell.typeIconButton.setImage(#imageLiteral(resourceName: "achievement_1"), for: .normal)
            } else {
                cell.typeIconButton.setImage(#imageLiteral(resourceName: "graph_1"), for: .normal)
            }
        } else {
            cell.typeIconButton.setImage(#imageLiteral(resourceName: "graph_1"), for: .normal)
        }

        cell.titleLabel.text = task.title
        cell.titleLabel.sizeToFit()
        
        cell.detailsLabel.text = task.details
        cell.detailsLabel.sizeToFit()
        
        let date = task.date
        let testdate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let dateComponents = (Calendar.current).dateComponents([.year, .month, .day, .weekday], from: date as! Date)
        let dateComponents2 = (Calendar.current).dateComponents([.year, .month, .day], from: testdate )
        
        let year = dateComponents.year
        let testYear = dateComponents2.year
        
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![dateComponents.month! - 1]
        let testMonthSymbol = months![dateComponents2.month! - 1]
        
        let day = dateComponents.day!
        let testDay = dateComponents2.day!
        
        let weekday = dateComponents.weekday!

        
        let daySymbol = "\(day)"
        var weekdaySymbol = String()
        
        if year == testYear && monthSymbol == testMonthSymbol && day == testDay {
            weekdaySymbol = "Today"
        } else if year == testYear && monthSymbol == testMonthSymbol && day == testDay + 1 {
            weekdaySymbol = "Tomorrow"
        } else {
            if weekday == 1 {
                weekdaySymbol = "Sunday"
            } else if weekday == 2 {
                weekdaySymbol = "Monday"
            } else if weekday == 3 {
                weekdaySymbol = "Tuesday"
            } else if weekday == 4 {
                weekdaySymbol = "Wednesday"
            } else if weekday == 5 {
                weekdaySymbol = "Thursday"
            } else if weekday == 6 {
                weekdaySymbol = "Friday"
            } else if weekday == 7 {
                weekdaySymbol = "Saturday"
            } else {
                print("something went wrong getting weekdaySymbol O_o")
            }
        }
        cell.weekdayLabel.text = "\(weekdaySymbol)"
        cell.dateLabel.text = "\(monthSymbol) \(daySymbol)"
        
        cell.checkIconButton.accessibilityIdentifier = String(describing: task.objectID)

        if task.isComplete == true {
            cell.backgroundColor = UIColor.green
            cell.titleLabel.textColor = UIColor.black
            cell.detailsLabel.textColor = UIColor.black
            cell.checkIconButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            if task.priority == 0 {
                cell.backgroundColor = UIColor.clear
            } else {
                var colorBasisBG = Float()
                var colorBasisTitle: Float = 0.0
                if task.priority == 1 {
                    colorBasisBG = 1.0
                } else if task.priority == 2 {
                    colorBasisBG = 0.9
                } else if task.priority == 3 {
                    colorBasisBG = 0.8
                } else if task.priority == 4 {
                    colorBasisBG = 0.7
                } else if task.priority == 5 {
                    colorBasisBG = 0.6
                } else if task.priority == 6 {
                    colorBasisBG = 0.5
                } else if task.priority == 7 {
                    colorBasisBG = 0.4
                } else if task.priority == 8 {
                    colorBasisBG = 0.3
                    colorBasisTitle = 0.1
                } else if task.priority == 9 {
                    colorBasisBG = 0.1
                    colorBasisTitle = 0.8
                } else if task.priority == 10 {
                    colorBasisBG = 0.0
                    colorBasisTitle = 1.0
                }
                cell.backgroundColor = UIColor(red: 1.0, green: CGFloat(colorBasisBG), blue: 0.0, alpha: 1.0)
                cell.titleLabel.textColor = UIColor(white: CGFloat(colorBasisTitle), alpha: 1.0)
                cell.detailsLabel.textColor = UIColor(white: CGFloat(colorBasisTitle), alpha: 1.0)
                cell.checkIconButton.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (selectedIndex == indexPath.row) {
            return 125
        } else {
            return 42
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = currentArray[indexPath.row]
        
        if (selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
            state = 1
            if hide == true {
                hide = false
            }
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let task = currentArray[indexPath.row]
        context.delete(task)
        do {
            try context.save()
        } catch {
            print ("\(error)")
        }
        tasks.remove(at: indexPath.row)
        determineCurrentArray()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "AddTaskSegue", sender: indexPath)
    }
    
//MARK...................................DELEGATE METHODS.....

    func itemSaved(by controller: AddTaskViewController, with title: String, with details: String, with type: String, with priority: Int16, with date: NSDate, at indexPath: NSIndexPath?) {
        if let iP = indexPath {
            let task = currentArray[iP.row]
            task.title = title
            task.details = details
            task.type = type
            task.priority = priority
            task.date = date as NSDate?
        } else {
            let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
            task.title = title
            task.details = details
            task.type = type
            task.priority = priority
            task.date = date as NSDate?
            tasks.append(task)
        }
        
        do {
            try context.save()
            print ("context.saved!")
        } catch {
            print("\(error)")
        }
        determineCurrentArray()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }


//MARK...................................SEGUES...............

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print (sender!)
        if let send = sender {
            if send is NSIndexPath {
                let nC = segue.destination as! UINavigationController
                let addTaskViewController = nC.topViewController as! AddTaskViewController
                addTaskViewController.addTaskDelegate = self
                let indexPath = sender as! NSIndexPath
                var task = Task()
                task = currentArray[indexPath.row]
                addTaskViewController.task = task
                addTaskViewController.indexPath = indexPath
            } else {
                let nC = segue.destination as! UINavigationController
                let addTaskViewController = nC.topViewController as! AddTaskViewController
                addTaskViewController.addTaskDelegate = self
            }
        }
    }
    
//MARK...................................OUT..................

    @IBOutlet weak var sortCompletedButton: UIButton!
    @IBOutlet weak var sortPriorityButton: UIButton!
    @IBOutlet weak var sortTypeButton: UIButton!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var tomorrowButton: UIButton!
    @IBOutlet weak var dateToggleButton: UIButton!
    
//MARK...................................ACT..................
    @IBAction func checkIconPressed(_ sender: UIButton) {
        taskID = sender.accessibilityIdentifier
        var check: Bool?
        for task in currentArray {
            if String(describing: task.objectID) == taskID! {
                do {
                    try context.save()
                    print ("context.saved!")
                } catch {
                    print("\(error)")
                }
                if task.isComplete == true {
                    if completedTasks.count > 0 {
                        for t in completedTasks {
                            if t == task {
                                check = false
                            } else {
                                check = true
                            }
                        }
                    } else {
                        completedTasks.append(task)
                    }
                    if check == true {
                        completedTasks.append(task)
                    }
                } else {
                    var indexToRemove = 0
                    if completedTasks.count > 0 {
                        for t in completedTasks {
                            if t == task {
                                if indexToRemove < completedTasks.count {
                                    completedTasks.remove(at: indexToRemove)
                                } else {
                                    print("good here")
                                }
                            }
                            indexToRemove += 1
                        }
                    } else {
                        print("something went wrong...")
                    }
                }
                tableView.reloadData()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        print(sender.tag)
        let tag = sender.tag
        if tag == 0 {
            print("current completedTasks: ", completedTasks)
            if completedTasks.count > 0 {
                if sortCompletedButton.layer.opacity == 0.4 {
                    showSorted = true
                    sortBy = "complete"
                    determineCurrentArray()
                    tableView.reloadData()
                    sortCompletedButton.layer.opacity = 1
                    if sortPriorityButton.layer.opacity == 1 {
                        sortPriorityButton.layer.opacity = 0.4
                    }
                    if sortTypeButton.layer.opacity == 1 {
                        sortTypeButton.layer.opacity = 0.4
                    }
                    if dateToggleButton.layer.opacity == 1 {
                        dateToggleButton.layer.opacity = 0.4
                    }
                } else {
                    showSorted = false
                    sortBy = ""
                    completedTasks = [Task]()
                    determineCurrentArray()
                    tableView.reloadData()
                    sortCompletedButton.layer.opacity = 0.4
                }
            }
        } else if tag == 1 {
            if sortOrderPriority == 0 {
                sortOrderPriority = 1
            } else if sortOrderPriority == 1 {
                sortOrderPriority = 2
            } else if sortOrderPriority == 2 {
                sortOrderPriority = 0
            }
            
            if sortOrderPriority == 0 {
                if sortPriorityButton.layer.opacity == 0.4 {
                    showSorted = true
                    sortBy = "priority"
                    determineCurrentArray()
                    tableView.reloadData()
                    sortPriorityButton.layer.opacity = 1
                    if sortCompletedButton.layer.opacity == 1 {
                        sortCompletedButton.layer.opacity = 0.4
                    }
                    if sortTypeButton.layer.opacity == 1 {
                        sortTypeButton.layer.opacity = 0.4
                    }
                    if dateToggleButton.layer.opacity == 1 {
                        dateToggleButton.layer.opacity = 0.4
                    }
                }
            } else if sortOrderPriority == 1 {
                showSorted = true
                sortBy = "priority"
                determineCurrentArray()
                tableView.reloadData()
                sortPriorityButton.layer.opacity = 1
                if sortCompletedButton.layer.opacity == 1 {
                    sortCompletedButton.layer.opacity = 0.4
                }
                if sortTypeButton.layer.opacity == 1 {
                    sortTypeButton.layer.opacity = 0.4
                }
                if dateToggleButton.layer.opacity == 1 {
                    dateToggleButton.layer.opacity = 0.4
                }
            } else {
                showSorted = false
                sortBy = ""
                determineCurrentArray()
                tableView.reloadData()
                sortPriorityButton.layer.opacity = 0.4
            }
        } else if tag == 2 {
            if sortOrderType == 0 {
                sortOrderType = 1
            } else if sortOrderType == 1 {
                sortOrderType = 2
            } else if sortOrderType == 2 {
                sortOrderType = 0
            }
            if sortOrderType == 0 {
                if sortTypeButton.layer.opacity == 0.4 {
                    showSorted = true
                    sortBy = "type"
                    determineCurrentArray()
                    tableView.reloadData()
                    sortTypeButton.layer.opacity = 1
                    if sortCompletedButton.layer.opacity == 1 {
                        sortCompletedButton.layer.opacity = 0.4
                    }
                    if sortPriorityButton.layer.opacity == 1 {
                        sortPriorityButton.layer.opacity = 0.4
                    }
                    if dateToggleButton.layer.opacity == 1 {
                        dateToggleButton.layer.opacity = 0.4
                    }
                }
            } else if sortOrderType == 1 {
                showSorted = true
                sortBy = "type"
                determineCurrentArray()
                tableView.reloadData()
                sortTypeButton.layer.opacity = 1
                if sortCompletedButton.layer.opacity == 1 {
                    sortCompletedButton.layer.opacity = 0.4
                }
                if sortPriorityButton.layer.opacity == 1 {
                    sortPriorityButton.layer.opacity = 0.4
                }
                if dateToggleButton.layer.opacity == 1 {
                    dateToggleButton.layer.opacity = 0.4
                }
            } else {
                showSorted = false
                sortBy = ""
                determineCurrentArray()
                tableView.reloadData()
                sortTypeButton.layer.opacity = 0.4
            }
        }
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        if todayButton.layer.opacity == 0.4 {
            todayButtonOn = true
            tomorrowButtonOn = false
            todayButton.layer.opacity = 1
            tomorrowButton.layer.opacity = 0.4
            showSorted = false
            determineCurrentArray()
            tableView.reloadData()
        } else {
            todayButtonOn = false
            todayButton.layer.opacity = 0.4
            determineCurrentArray()
            tableView.reloadData()
        }
    }
    
    @IBAction func tomorrowButtonPressed(_ sender: UIButton) {
        if tomorrowButton.layer.opacity == 0.4 {
            tomorrowButtonOn = true
            todayButtonOn = false
            tomorrowButton.layer.opacity = 1
            todayButton.layer.opacity = 0.4
            showSorted = false
            determineCurrentArray()
            tableView.reloadData()
        } else {
            tomorrowButtonOn = false
            tomorrowButton.layer.opacity = 0.4
            determineCurrentArray()
            tableView.reloadData()
        }
    }
    
    @IBAction func dateToggleButtonPressed(_ sender: UIButton) {
        if dateToggleButton.layer.opacity == 0.4 {
            dateToggleButton.layer.opacity = 1
            if sortCompletedButton.layer.opacity == 1 {
                sortCompletedButton.layer.opacity = 0.4
            }
            if sortPriorityButton.layer.opacity == 1 {
                sortPriorityButton.layer.opacity = 0.4
            }
            if sortTypeButton.layer.opacity == 1 {
                sortTypeButton.layer.opacity = 0.4
            }
        }
        if dateMode == 0 {
            dateMode = 1
            determineCurrentArray()
            tableView.reloadData()
        } else {
            dateMode = 0
            determineCurrentArray()
            tableView.reloadData()
        }
    }
    
//MARK...................................UI LIFECYCLE.........

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        dateMode = 0
        todayButtonOn = false
        tomorrowButtonOn = false

        determineCurrentArray()
        
        showSorted = false
        sortOrderPriority = 2
        sortOrderType = 2
        sortCompletedButton.layer.opacity = 0.4
        sortPriorityButton.layer.opacity = 0.4
        sortTypeButton.layer.opacity = 0.4
        
        todayButton.layer.opacity = 0.4
        tomorrowButton.layer.opacity = 0.4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
