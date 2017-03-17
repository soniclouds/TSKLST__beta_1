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
    var sortOrderPriority: Int? // for priority: if 0, 0-10 ascending -- if 1, 10-0 descending -- if 2, reset
    // for type: if 0... work-home-family-errands-life-other ascending -- if 1, reverse -- if 2, reset
    var sortOrderType: Int?
    
    var todayButtonOn: Bool?
    var tomorrowButtonOn: Bool?
    
    var selectedTask: Task?
    
    var taskID: String?
    
    var selectedIndex = -1
    
    var hide = true
    var state = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK...................................FUNC.................
    
    func dateIsToday(date: Date) -> Bool {
        let testDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        // extract the date elements
        let dateComponents = (Calendar.current).dateComponents([.year, .month, .day, .weekday], from: date)
        let dateComponents2 = (Calendar.current).dateComponents([.year, .month, .day], from: testDate )
        
        let year = dateComponents.year
        let testYear = dateComponents2.year
        
        let months = dateFormatter.shortMonthSymbols
        
        let monthSymbol = months![dateComponents.month! - 1]
        let testMonthSymbol = months![dateComponents2.month! - 1]
        
        let day = dateComponents.day!
        let testDay = dateComponents2.day!
        
        
        
        // compare dates for labeling
        // if date of task is today
        if year == testYear && monthSymbol == testMonthSymbol && day == testDay {
            print("same date!")
            return true
        } else {
            return false
        }
    }
    
    func dateIsTomorrow(date: Date) -> Bool {
        let testDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        // extract the date elements
        let dateComponents = (Calendar.current).dateComponents([.year, .month, .day, .weekday], from: date)
        let dateComponents2 = (Calendar.current).dateComponents([.year, .month, .day], from: testDate )
        
        let year = dateComponents.year
        let testYear = dateComponents2.year
        
        let months = dateFormatter.shortMonthSymbols
        
        let monthSymbol = months![dateComponents.month! - 1]
        let testMonthSymbol = months![dateComponents2.month! - 1]
        
        let day = dateComponents.day!
        let testDay = dateComponents2.day!
        
        // if date of task is tomorrow
        if year == testYear && monthSymbol == testMonthSymbol && day == testDay + 1 {
            return true
        } else {
            return false
        }
    }
    
    
    // this will be called at any time to determine the current array, using variable data
    func determineCurrentArray(){
        // factor 1: is showSorted true or false
        // if it's true, then we check all other variables
        if showSorted == true {
            if sortBy == "complete" {
                if completedTasks.count > 0 {
                    //                    concatArray = concatAllTasks() as! [Task]
                    //                    task = concatArray[indexPath.row]
                    
                    // handle today button in context of sorted arrays -- get respective arrays as usual, but FILTER them accordingly if the conditions are met
                    if todayButtonOn == true { // if we are sorting by completed tasks, and only want to see TODAY
                        // save concatAllTasks() into a temp array, filter that, then assign it to currentArray
                        let tempArray = concatAllTasks() as! [Task]
                        var resultArray = [Task]()
                        for tT in tempArray { // for each task in the tempArray, IF the task.date equals today, then append to resultArray
                            if dateIsToday(date: tT.date as! Date) == true {
                                print("just called dateIsToday() from determineCurrentArray() -- dateIsToday() is TRUE")
                                resultArray.append(tT)
                            }
//                            if tT.date == testDate as NSDate {
//                                resultArray.append(tT)
//                            } // else, don't do anything -- return the resultArray regardless
                        }
                        currentArray = resultArray
                    } else if tomorrowButtonOn == true {
                        let tempArray = concatAllTasks() as! [Task]
                        var resultArray = [Task]()
                        for tT in tempArray { // for each task in the tempArray, IF the task.date equals tomorrow, then append to resultArray
                            if dateIsTomorrow(date: tT.date as! Date) == true {
                                print("just called dateIsTomorrow() from determineCurrentArray() -- dateIsTomorrow() is TRUE")
                                resultArray.append(tT)
                            }
                            
                            
//                            if tT.date == testDate as NSDate {
//                                resultArray.append(tT)
//                            } // else, don't do anything -- return the resultArray regardless
                        }
                        currentArray = resultArray

                    } else { // if neither button is switched on, THEN do what was originally the default
                        currentArray = concatAllTasks() as! [Task]
                        print(currentArray) // this is EITHER a concatenated array of completed/incompleted, or simply the completedTasks array
                    }
                }
            } else if sortBy == "priority" {
                //                concatArray = concatAllTasks() as! [Task]
                //                task = concatArray[indexPath.row]
                
                if todayButtonOn == true { // if we are sorting by completed tasks, and only want to see TODAY
                    // save concatAllTasks() into a temp array, filter that, then assign it to currentArray
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray { // for each task in the tempArray, IF the task.date equals today, then append to resultArray
                        if dateIsToday(date: tT.date as! Date) == true {
                            print("just called dateIsToday() from determineCurrentArray() -- dateIsToday() is TRUE")
                            resultArray.append(tT)
                        }
                        //                            if tT.date == testDate as NSDate {
                        //                                resultArray.append(tT)
                        //                            } // else, don't do anything -- return the resultArray regardless
                    }
                    currentArray = resultArray
                } else if tomorrowButtonOn == true {
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray { // for each task in the tempArray, IF the task.date equals tomorrow, then append to resultArray
                        if dateIsTomorrow(date: tT.date as! Date) == true {
                            print("just called dateIsTomorrow() from determineCurrentArray() -- dateIsTomorrow() is TRUE")
                            resultArray.append(tT)
                        }
                        
                        
                        //                            if tT.date == testDate as NSDate {
                        //                                resultArray.append(tT)
                        //                            } // else, don't do anything -- return the resultArray regardless
                    }
                    currentArray = resultArray
                    
                } else {
                    currentArray = concatAllTasks() as! [Task]
                }
            } else if sortBy == "type" {
                
                if todayButtonOn == true { // if we are sorting by completed tasks, and only want to see TODAY
                    // save concatAllTasks() into a temp array, filter that, then assign it to currentArray
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray { // for each task in the tempArray, IF the task.date equals today, then append to resultArray
                        if dateIsToday(date: tT.date as! Date) == true {
                            print("just called dateIsToday() from determineCurrentArray() -- dateIsToday() is TRUE")
                            resultArray.append(tT)
                        }
                        //                            if tT.date == testDate as NSDate {
                        //                                resultArray.append(tT)
                        //                            } // else, don't do anything -- return the resultArray regardless
                    }
                    currentArray = resultArray
                } else if tomorrowButtonOn == true {
                    let tempArray = concatAllTasks() as! [Task]
                    var resultArray = [Task]()
                    for tT in tempArray { // for each task in the tempArray, IF the task.date equals tomorrow, then append to resultArray
                        if dateIsTomorrow(date: tT.date as! Date) == true {
                            print("just called dateIsTomorrow() from determineCurrentArray() -- dateIsTomorrow() is TRUE")
                            resultArray.append(tT)
                        }
                        
                        
                        //                            if tT.date == testDate as NSDate {
                        //                                resultArray.append(tT)
                        //                            } // else, don't do anything -- return the resultArray regardless
                    }
                    currentArray = resultArray
                    
                } else {
//                    concatArray = concatAllTasks() as! [Task]
//                    print("printing concatArray...", concatArray)
//                    //                task = concatArray[indexPath.row]
//                    currentArray = concatArray
//                    
                    currentArray = concatAllTasks() as! [Task]
                }
            }
            
            
        } // if it's false
        else {
            // get/show all tasks in date order, depending on dateMode
            getAll() // this populates tasks and reverseTasks arrays by date, or does nothing if we have no tasks yet
            
            
            // EITHER handle todayButton
            if todayButtonOn == true {
                var tempArray = [Task]()
                if dateMode == 0 { // we know to draw from the tasks array
                    tempArray = tasks
                } else {
                    tempArray = tasksDateReverse
                }
                var resultArray = [Task]()
                for tT in tempArray { // for each task in the tempArray, IF the task.date equals today, then append to resultArray
                    if dateIsToday(date: tT.date as! Date) == true {
                        print("just called dateIsToday() AGAIN from determineCurrentArray() -- dateIsToday() is TRUE")
                        resultArray.append(tT)
                    }
                    //                            if tT.date == testDate as NSDate {
                    //                                resultArray.append(tT)
                    //                            } // else, don't do anything -- return the resultArray regardless
                }
                currentArray = resultArray
            }
            // OR handle tomorrowButton
            else if tomorrowButtonOn == true {
                var tempArray = [Task]()
                if dateMode == 0 { // we know to draw from the tasks array
                    tempArray = tasks
                } else {
                    tempArray = tasksDateReverse
                }
                var resultArray = [Task]()
                for tT in tempArray { // for each task in the tempArray, IF the task.date equals today, then append to resultArray
                    if dateIsTomorrow(date: tT.date as! Date) == true {
                        print("just called dateIsTomorrow() AGAIN from determineCurrentArray() -- dateIsTomorrow() is TRUE")
                        resultArray.append(tT)
                    }
                    //                            if tT.date == testDate as NSDate {
                    //                                resultArray.append(tT)
                    //                            } // else, don't do anything -- return the resultArray regardless
                }
                currentArray = resultArray
            } else { // if neither button is switched, on carry on with the data set by getAll()
                if dateMode == 0 {
                    currentArray = tasks
                } else {
                    currentArray = tasksDateReverse
                }
            }
        }
        // by now, we should have the correct currentArray for the current conditions
    }
    //        } else {
    ////            if dateMode == 0 {
    ////                task = tasks[indexPath.row]
    ////                cell.task = task
    ////            }
    ////            if dateMode == 1 {
    ////                task = tasksDateReverse[indexPath.row]
    ////                cell.task = task
    ////            }
    //            if sortBy == "complete" {
    //                if completedTasks.count > 0 {
    //                    print("in here nao -- showSorted = true, completedTasks.count > 0 -- completedTasks: ", completedTasks)
    //                    concatArray = concatAllTasks() as! [Task]
    ////                    task = concatArray[indexPath.row]
    //                    currentArray = concatArray
    //                    print(concatArray)
    //                }
    //            } else if sortBy == "priority" {
    //
    //                concatArray = concatAllTasks() as! [Task]
    ////                task = concatArray[indexPath.row]
    //                currentArray = concatArray
    //
    //            } else if sortBy == "type" {
    //                concatArray = concatAllTasks() as! [Task]
    //                print("printing concatArray...", concatArray)
    ////                task = concatArray[indexPath.row]
    //                currentArray = concatArray
    //            }
    //
    //        }
    //        // we now have the correct task for each cell, given the current array
    //        task = currentArray[indexPath.row]
    //        // set the task property of the cell now, so we can use it
    //        cell.task = task
    //        if let type = task.type {
    //            if type == "work" {
    //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "work"), for: .normal)
    //            } else if type == "home" {
    //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "house_chores_1"), for: .normal)
    //            } else if type == "family" {
    //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "family_1"), for: .normal)
    //            } else if type == "errands" {
    //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "notepad_1"), for: .normal)
    //            } else if type == "life events" {
    //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "achievement_1"), for: .normal)
    //            } else {
    //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "graph_1"), for: .normal)
    //            }
    //        } else {
    //            cell.typeIconButton.setImage(#imageLiteral(resourceName: "graph_1"), for: .normal)
    //        }
    //
    //        if showSorted != true {
    ////            cell.titleLabel.text = tasks[indexPath.row].title
    //            cell.titleLabel.text = task.title
    //            cell.titleLabel.sizeToFit()
    //
    //            cell.detailsLabel.text = task.details
    //            cell.detailsLabel.sizeToFit()
    //
    //            //        // format and set the date
    //            let date = task.date
    //            let testdate = Date()
    //
    //            let dateFormatter = DateFormatter()
    //            dateFormatter.dateStyle = .short
    //
    //            // extract the date elements
    //            let dateComponents = (Calendar.current).dateComponents([.year, .month, .day, .weekday], from: date as! Date)
    //            let dateComponents2 = (Calendar.current).dateComponents([.year, .month, .day], from: testdate )
    //
    //            let year = dateComponents.year
    //            let testYear = dateComponents2.year
    //
    //            let months = dateFormatter.shortMonthSymbols
    //
    //            let monthSymbol = months![dateComponents.month! - 1]
    //            let testMonthSymbol = months![dateComponents2.month! - 1]
    //
    //            let day = dateComponents.day!
    //            let testDay = dateComponents2.day!
    //
    //            let weekday = dateComponents.weekday!
    //            print("==========================", day)
    //            print(weekday)
    //
    //            let daySymbol = "\(day)"
    //            var weekdaySymbol = String()
    //
    //
    //            // compare dates
    //            // if date of task is today
    //            if year == testYear && monthSymbol == testMonthSymbol && day == testDay {
    //                print("same date!")
    //                weekdaySymbol = "Today"
    //            } else if year == testYear && monthSymbol == testMonthSymbol && day == testDay + 1 {
    //                weekdaySymbol = "Tomorrow"
    //                } else {
    //                    if weekday == 1 {
    //                        weekdaySymbol = "Sunday"
    //                    } else if weekday == 2 {
    //                        weekdaySymbol = "Monday"
    //                    } else if weekday == 3 {
    //                        weekdaySymbol = "Tuesday"
    //                    } else if weekday == 4 {
    //                        weekdaySymbol = "Wednesday"
    //                    } else if weekday == 5 {
    //                        weekdaySymbol = "Thursday"
    //                    } else if weekday == 6 {
    //                        weekdaySymbol = "Friday"
    //                    } else if weekday == 7 {
    //                        weekdaySymbol = "Saturday"
    //                    } else {
    //                        print("something went wrong getting weekdaySymbol O_o")
    //                    }
    //                }
    //            cell.weekdayLabel.text = "\(weekdaySymbol)"
    //            cell.dateLabel.text = "\(monthSymbol) \(daySymbol)"
    //            //
    //
    //
    //
    //        } else {
    //            cell.titleLabel.text = concatArray[indexPath.row].title
    //            cell.titleLabel.sizeToFit()
    //
    //            cell.detailsLabel.text = concatArray[indexPath.row].details
    //            cell.detailsLabel.sizeToFit()
    //            let date = concatArray[indexPath.row].date
    //            let dateFormatter = DateFormatter()
    //            dateFormatter.dateStyle = .short
    //            cell.dateLabel.text = dateFormatter.string(from: date as! Date)
    //
    //            cell.task = task
    //        }
    
    
    
    
    
    
    // this takes in any raw array, sorts all elements by ascending date and returns the sorted version of the original array
    func sortDates(initialArray: [Task]) -> [Task] {
        var sortedArray = [Task]()
        print("initialArray passed by getAll(): ", initialArray)
        print("initialArray[0]: ", initialArray[0])
        var check = initialArray[0].date as! Date
        print("here is our 'check' date for sorting: ", check)
        for var i in 0..<initialArray.count {
            if (initialArray[i].date as! Date) < check {
                check = initialArray[i].date as! Date
            }
        }
        sortedArray.append(initialArray[0])
        print("just added first element to sortedArray", sortedArray)
        for var j in 1..<initialArray.count {
            print("getting here...")
            print("sortedArray.count: ", sortedArray.count)
            if (initialArray[j].date as! Date) >= ((sortedArray[j - 1]).date as! Date) {
                sortedArray.append(initialArray[j])
                print((initialArray[j].date as! Date) >= ((sortedArray[j-1]).date as! Date))
            } else {
//                var count = 0
//                while count < sortedArray.count {
//                    if (initialArray[j].date as! Date) < sortedArray[count].date as! Date {
//                    sortedArray.insert(initialArray[j], at: count)
//                    }
//                    count += 1
//                }
//                print("in dat els")
//
////                sortedArray.insert(initialArray[j], at: 0)
////                print("just inserted an earlier task")
//            }
            
                
                
                
//                // find the index at which to insert
//                var index = Int()
//                for var t in 0..<sortedArray.count {
//                    if (initialArray[j].date as! Date) < (sortedArray[t].date as! Date) {
//                        index = t
//                    }
//                }
//                // simply insert ONCE
//                sortedArray.insert(initialArray[j], at: index)
//                print("just inserted an earlier date at index: ", index)
                
//                var count = 0
//                while count == 0 {
                    for var t in 0..<sortedArray.count {
                        if (initialArray[j].date as! Date) < (sortedArray[t].date as! Date) {
                            sortedArray.insert(initialArray[j], at: t)
//                            count = 1
                            break
                        } else {
                            print("in the else of the tasks insertion...and nothing went wrong! yay! ^_^ ")
                        }
                    }
//                }
            }
            }
        
        print("in sortDate() -- should have the date sorted task array now...: ", sortedArray)
        return sortedArray
    }
    
    // this takes in an already sorted array, and returns the reversed version
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
            print("just fetched initialTasks: ", initialTasks)
            // initialize check to compare earliest date
            //======================================================================================================
            //            var check = initialTasks[0].date as! Date
            //            for var i in 0..<initialTasks.count {
            //                if (initialTasks[i].date as! Date) < check {
            //                    // this gets the earliest date in the initialTasks array as a basis for comparison
            //                    check = initialTasks[i].date as! Date
            //                }
            //            }
            //            // now we have a check to compare against
            //
            //            // append the first task to get it started
            //            tasks.append(initialTasks[0])
            //            // initialize a count to loop through initialTasks array, STARTING at index 1 (since we've already sent index 0)
            ////            var count = 1
            //            // to make sure we scan every task in our initialTasks array
            ////            while count < initialTasks.count {
            //                // starting the check at index 1, in keeping with the initial count
            //                for var j in 1..<initialTasks.count {
            //                    if (initialTasks[j].date as! Date) >= ((tasks[j - 1]).date as! Date) {
            //                        tasks.append(initialTasks[j])
            //                    } else {
            //                        // if the next initialTask is LESS than the current last element in tasks
            //                        // loop through tasks and compare the initialTask.date to the task.date
            //                        // if LESS than, insert initialTask at task's index position (t)
            //                        for var t in 0..<tasks.count {
            //                            if (initialTasks[j].date as! Date) < (tasks[t].date as! Date) {
            //                                tasks.insert(initialTasks[j], at: t)
            //                            } else {
            //                                print("in the else of the tasks insertion...and nothing went wrong! yay! ^_^ ")
            //                            }
            //                        }
            ////                        tasks.insert(initialTasks[j], at: (j - 1))
            //                    }
            //                }
            ////                count += 1
            ////            }
            ////            tasks = initialTasks
            //            print("should have the date sorted task array now...: ", tasks)
            //            var dateRevIndex = tasks.count - 1
            //            while dateRevIndex >= 0 {
            //                tasksDateReverse.append(tasks[dateRevIndex])
            //                dateRevIndex -= 1
            //            }
            //======================================================================================================
            if initialTasks.count > 0 {
                tasks = sortDates(initialArray: initialTasks)
                
                print("in getAll() -- should have the date sorted task array now...: ", tasks)
                tasksDateReverse = simpleReverseAppend(sortedArray: tasks)
                print("and here is the reversed date array! ", tasksDateReverse)
            }
            
            // carry on here regardless of whether or not we have tasks
            for t in tasks {
                if t.isComplete == true {
                    print("getting inside here.......")
                    //                    if completedTasks.count == 0 {
                    print("######################## completedTasks.count == 0 #####################")
                    completedTasks.append(t)
                    //                    } else {
                    //                        for cT in completedTasks {
                    
                    //                            if t != cT {
                    
                    //                                completedTasks.append(t)
                }
            }
            //                    }
            //                }
            //            }
        } catch {
            print("\(error)")
        }
    }
    //
    //    func sortCompleted(){
    ////        var tempArray = [Task]()
    ////        for task in tasks {
    ////            if task.isComplete == true {
    ////                tempArray.append(task)
    ////            }
    ////        }
    ////        if tempArray.count < tasks.count {
    ////            for task in tasks {
    ////                if task.isComplete == false {
    ////                    tempArray.append(task)
    ////                }
    ////            }
    ////        }
    ////        tasks = tempArray
    //        if showSorted == false {
    //            showSorted = true
    //        } else {
    //            showSorted = false
    //        }
    //
    //        tableView.reloadData()
    //    }
    
    func concatAllTasks() -> Array<Any> {
        var leftoversArray = [Task]()
        var concArr = [Task]()
        //        var isLeftover = Bool()
        
        if sortBy == "complete" {
            // if there are any tasks not yet completed, get those
            // currently, I am ONLY basing this on all tasks in order
            if completedTasks.count < tasks.count {
                print("just entered concatAllTasks() - if sortBy == complete - if completedTasks.com < tasks.count -- ")
                print("tasks array: ", tasks)
                print("currentArray: ", currentArray)
                print("===========completedTasks: ", completedTasks)
                //            for var i in 0..<tasks.count {
                //                print("tasks[i]: ", tasks[i])
                //                for var j in 0..<completedTasks.count {
                //                    print("completedTasks[j]: ", completedTasks[j])
                //                    if tasks[i] != completedTasks[j] {
                //                        isLeftover = true
                //                        if leftoversArray.count > 0 {
                //                            for l in leftoversArray {
                //                                if tasks[i] != l {
                //                                    leftoversArray.append(tasks[i])
                //                                    print("getting here -- appending new task to leftoversArray")
                //                                }
                //                            }
                //                        } else {
                //                            leftoversArray.append(tasks[i])
                //                            print("getting here -- initialize leftoversArray")
                //                        }
                //                    } else {
                //                        isLeftover = false
                //                    }
                //                }
                ////                if isLeftover == true {
                ////                    leftoversArray.append(tasks[i])
                ////                }
                //            }
                for task in currentArray {
                    if task.isComplete == false {
                        leftoversArray.append(task)
                    }
                }
                
                concArr = completedTasks + leftoversArray
                
                
                print("returning concatAllTasks: ", concArr)
                print("leftoversArray: ", leftoversArray)
                return concArr
            } else {
                return completedTasks
            }
            // by now, the determineCurrentArray() function has the correct array for the tableView to display
            
        } else if sortBy == "priority" {
            var start = Int()
            print("inside sortBy priority -- sortOrderPriority: ", sortOrderPriority)
            if sortOrderPriority == 2 {
                // reset task list by calling getAll(), then returning the neatly ordered tasks array as the currentArray
                getAll()
                return tasks // this is the newly refreshed tasks array
                
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
                print("returning priorityArray -- sortOrder == 0: ", priorityArray)
                return priorityArray
            } else if sortOrderPriority == 1 {
                print("getting here at least?")
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
                print("returning priorityArray -- sortOrder == 1: ", priorityArray)
                return priorityArray
            }
            
            
            
        }
        else if sortBy == "type" {
            var types = ["work", "fun", "home", "family", "life events", "errands", "other"]
            
            if sortOrderType == 2 { // reset
                getAll()
                return tasks
            }
            var typeArray = [Task]()
            
            
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
        //        if showSorted == false {
        //            return tasks.count
        //        } else {
        //            return 4
        //        }
        return currentArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        var task = Task()
        
        
        // let's assume we've already set the currentArray somewhere else
        // in that case, we just need to draw info from that array, rather than performing case-by-case logic
        print("in cellForRow... this is the currentArray we're dealing with: ", currentArray)
        task = currentArray[indexPath.row]
        print("and this is the task for each row", task)
        cell.task = task // set the task property for the cell
        // load the correct image based on the type of task
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
        } else { // in the off-chance the task does not have a type (defensive)
            cell.typeIconButton.setImage(#imageLiteral(resourceName: "graph_1"), for: .normal)
        }
        // by this point we have the correct task, cell.task, and icon image
        // let's set the rest of the data
        
        // set the title
        cell.titleLabel.text = task.title
        cell.titleLabel.sizeToFit()
        
        // set the details
        cell.detailsLabel.text = task.details
        cell.detailsLabel.sizeToFit()
        
        // format and set the date
        let date = task.date
        let testdate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        // extract the date elements
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
        print("==========================", day)
        print(weekday)
        
        let daySymbol = "\(day)"
        var weekdaySymbol = String()
        
        
        // compare dates for labeling
        // if date of task is today
        if year == testYear && monthSymbol == testMonthSymbol && day == testDay {
            print("same date!")
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
        
        // by this point, we have set all the data for our cell
        
        
        //============================================================================================================================================
        //        if showSorted != true {
        //            if dateMode == 0 {
        ////                task = tasks[indexPath.row]
        ////                cell.task = task
        //                currentArray = tasks
        //            }
        //            if dateMode == 1 {
        ////                task = tasksDateReverse[indexPath.row]
        ////                cell.task = task
        //                currentArray = tasksDateReverse
        //            }
        ////            cell.task = currentArray[indexPath.row]
        //        } else {
        ////            if dateMode == 0 {
        ////                task = tasks[indexPath.row]
        ////                cell.task = task
        ////            }
        ////            if dateMode == 1 {
        ////                task = tasksDateReverse[indexPath.row]
        ////                cell.task = task
        ////            }
        //            if sortBy == "complete" {
        //                if completedTasks.count > 0 {
        //                    print("in here nao -- showSorted = true, completedTasks.count > 0 -- completedTasks: ", completedTasks)
        //                    concatArray = concatAllTasks() as! [Task]
        ////                    task = concatArray[indexPath.row]
        //                    currentArray = concatArray
        //                    print(concatArray)
        //                }
        //            } else if sortBy == "priority" {
        //
        //                concatArray = concatAllTasks() as! [Task]
        ////                task = concatArray[indexPath.row]
        //                currentArray = concatArray
        //
        //            } else if sortBy == "type" {
        //                concatArray = concatAllTasks() as! [Task]
        //                print("printing concatArray...", concatArray)
        ////                task = concatArray[indexPath.row]
        //                currentArray = concatArray
        //            }
        //
        //        }
        //        // we now have the correct task for each cell, given the current array
        //        task = currentArray[indexPath.row]
        //        // set the task property of the cell now, so we can use it
        //        cell.task = task
        //        if let type = task.type {
        //            if type == "work" {
        //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "work"), for: .normal)
        //            } else if type == "home" {
        //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "house_chores_1"), for: .normal)
        //            } else if type == "family" {
        //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "family_1"), for: .normal)
        //            } else if type == "errands" {
        //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "notepad_1"), for: .normal)
        //            } else if type == "life events" {
        //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "achievement_1"), for: .normal)
        //            } else {
        //                cell.typeIconButton.setImage(#imageLiteral(resourceName: "graph_1"), for: .normal)
        //            }
        //        } else {
        //            cell.typeIconButton.setImage(#imageLiteral(resourceName: "graph_1"), for: .normal)
        //        }
        //
        //        if showSorted != true {
        ////            cell.titleLabel.text = tasks[indexPath.row].title
        //            cell.titleLabel.text = task.title
        //            cell.titleLabel.sizeToFit()
        //
        //            cell.detailsLabel.text = task.details
        //            cell.detailsLabel.sizeToFit()
        //
        //            //        // format and set the date
        //            let date = task.date
        //            let testdate = Date()
        //
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateStyle = .short
        //
        //            // extract the date elements
        //            let dateComponents = (Calendar.current).dateComponents([.year, .month, .day, .weekday], from: date as! Date)
        //            let dateComponents2 = (Calendar.current).dateComponents([.year, .month, .day], from: testdate )
        //
        //            let year = dateComponents.year
        //            let testYear = dateComponents2.year
        //
        //            let months = dateFormatter.shortMonthSymbols
        //
        //            let monthSymbol = months![dateComponents.month! - 1]
        //            let testMonthSymbol = months![dateComponents2.month! - 1]
        //
        //            let day = dateComponents.day!
        //            let testDay = dateComponents2.day!
        //
        //            let weekday = dateComponents.weekday!
        //            print("==========================", day)
        //            print(weekday)
        //
        //            let daySymbol = "\(day)"
        //            var weekdaySymbol = String()
        //
        //
        //            // compare dates
        //            // if date of task is today
        //            if year == testYear && monthSymbol == testMonthSymbol && day == testDay {
        //                print("same date!")
        //                weekdaySymbol = "Today"
        //            } else if year == testYear && monthSymbol == testMonthSymbol && day == testDay + 1 {
        //                weekdaySymbol = "Tomorrow"
        //                } else {
        //                    if weekday == 1 {
        //                        weekdaySymbol = "Sunday"
        //                    } else if weekday == 2 {
        //                        weekdaySymbol = "Monday"
        //                    } else if weekday == 3 {
        //                        weekdaySymbol = "Tuesday"
        //                    } else if weekday == 4 {
        //                        weekdaySymbol = "Wednesday"
        //                    } else if weekday == 5 {
        //                        weekdaySymbol = "Thursday"
        //                    } else if weekday == 6 {
        //                        weekdaySymbol = "Friday"
        //                    } else if weekday == 7 {
        //                        weekdaySymbol = "Saturday"
        //                    } else {
        //                        print("something went wrong getting weekdaySymbol O_o")
        //                    }
        //                }
        //            cell.weekdayLabel.text = "\(weekdaySymbol)"
        //            cell.dateLabel.text = "\(monthSymbol) \(daySymbol)"
        //            //
        //
        //
        //
        //        } else {
        //            cell.titleLabel.text = concatArray[indexPath.row].title
        //            cell.titleLabel.sizeToFit()
        //
        //            cell.detailsLabel.text = concatArray[indexPath.row].details
        //            cell.detailsLabel.sizeToFit()
        //            let date = concatArray[indexPath.row].date
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateStyle = .short
        //            cell.dateLabel.text = dateFormatter.string(from: date as! Date)
        //
        //            cell.task = task
        //        }
        //============================================================================================================================================
        
        cell.checkIconButton.accessibilityIdentifier = String(describing: task.objectID)
        
        //        cell.task = task
        //        print("testing task.isComplete...", task)
        
        
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
                //                var colorBasisDetails: Float = 0.0
                // if priority is 1, colorBasis should be 1.0
                if task.priority == 1 {
                    colorBasisBG = 1.0
                } else if task.priority == 2 {
                    colorBasisBG = 0.9
                } else if task.priority == 3 {
                    colorBasisBG = 0.8
                } else if task.priority == 4 {
                    colorBasisBG = 0.7
                    //                    colorBasisDetails = 0.1
                } else if task.priority == 5 {
                    colorBasisBG = 0.6
                    //                    colorBasisDetails = 0.1
                } else if task.priority == 6 {
                    colorBasisBG = 0.5
                    //                    colorBasisDetails = 0.5
                } else if task.priority == 7 {
                    colorBasisBG = 0.4
                    //                    colorBasisDetails = 0.8
                } else if task.priority == 8 {
                    colorBasisBG = 0.3
                    colorBasisTitle = 0.1
                    //                    colorBasisDetails = 0.9
                } else if task.priority == 9 {
                    colorBasisBG = 0.1
                    colorBasisTitle = 0.8
                    //                    colorBasisDetails = 1.0
                } else if task.priority == 10 {
                    colorBasisBG = 0.0
                    colorBasisTitle = 1.0
                    //                    colorBasisDetails = 1.0
                }
                cell.backgroundColor = UIColor(red: 1.0, green: CGFloat(colorBasisBG), blue: 0.0, alpha: 1.0)
                cell.titleLabel.textColor = UIColor(white: CGFloat(colorBasisTitle), alpha: 1.0)
                cell.detailsLabel.textColor = UIColor(white: CGFloat(colorBasisTitle), alpha: 1.0)
                cell.checkIconButton.setTitleColor(UIColor.lightGray, for: .normal)
            }
            //            if task.priority > 0 && task.priority < 5 {
            //                cell.backgroundColor = UIColor.yellow
            //                cell.titleLabel.textColor = UIColor.white
            //                cell.layer.opacity = 0.2
            //            } else if task.priority > 4 && task.priority < 8 {
            //                cell.backgroundColor = UIColor.orange
            //            } else if task.priority > 7 {
            //                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
            //
            //
            //            }
            
            //            cell.checkIconButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
        
        //        print("task isComplete? ", task.isComplete)
        //        print("inside cellForRow...; cell.detailsTopConstraint: ", cell.detailsTopConstraint.secondItem!.position.y)
        //        print("cell isChecked...? ", cell.isChecked)
        //        print("cell checkIconButton identifier: ", cell.checkIconButton.accessibilityIdentifier)
        return cell
    }
    
    // SEEMS LIKE EVERYTHING IS GOOD UP TO HERE
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (selectedIndex == indexPath.row) {
            return 105
        } else {
            return 42
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        selectedTask = currentArray[indexPath.row]
        print(selectedTask!)
        
        
        // if I click the same row again
        if (selectedIndex == indexPath.row) {
            selectedIndex = -1
            // if I click a different row
        } else {
            selectedIndex = indexPath.row
            state = 1
            if hide == true {
                hide = false
            }
        }
        
        
        self.tableView.beginUpdates()
        //        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        self.tableView.endUpdates()
        
        
        
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if let cell = tableView.cellForRow(at: indexPath) {
    //            if cell.accessoryType == .none {
    //                cell.accessoryType = .checkmark
    //
    //            } else if cell.accessoryType == .checkmark {
    //                cell.accessoryType = .none
    //            }
    //
    //
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //        let task = tasks[indexPath.row]
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
    
    //  when accessory button is tapped, segue with "AddItemSegue", but also pass in the indexPath
    // NOTE: this would also work with the add button
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // the indexPath indicates an 'edit'
        performSegue(withIdentifier: "AddTaskSegue", sender: indexPath)
        
    }
    //MARK...................................DELEGATE METHODS.....
    
    //    func itemSaved(by controller: AddTaskViewController, with title: String, with details: String, with type: String, with priority: Int16, with isComplete: Bool, with time: NSDate, with date: NSDate, at indexPath: NSIndexPath?) {
    //        if let iP = indexPath {
    //            let task = tasks[iP.row]
    //            task.title = title
    //            task.details = details
    //            task.type = type
    //            task.priority = priority
    //            task.isComplete = isComplete
    //            task.time = time as NSDate?
    //            task.date = date as NSDate?
    //        } else {
    //            let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
    //            task.title = title
    //            task.details = details
    //            task.type = type
    //            task.priority = priority
    //            task.isComplete = isComplete
    //            task.time = time as NSDate?
    //            task.date = date as NSDate?
    //            tasks.append(task)
    //        }
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
    
    
    
    //    func taskChecked(by controller: MainTableViewController, with isComplete: Bool, at: indexPath) {
    //
    //    }
    //MARK...................................SEGUES...............
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        print (sender)
    //        // set the destination view controller
    //        let nC = segue.destination as! UINavigationController
    //        // tell the destination view controller to communicate with this one
    //        let addTaskViewController = nC.topViewController as! AddTaskViewController
    //        addTaskViewController.addTaskDelegate = self
    //        print ("add new task")
    //    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print (sender!)
        // unwrap sender
        if let send = sender {
            // if we clicked on a table item
            if send is NSIndexPath {
                // set the destination view controller
                let nC = segue.destination as! UINavigationController
                // tell the destination to communicate back
                let addTaskViewController = nC.topViewController as! AddTaskViewController
                addTaskViewController.addTaskDelegate = self
                // if an indexPath is sent, get it
                let indexPath = sender as! NSIndexPath
                // get item from items array where the index matches the index of the row
                var task = Task()
                //                if showSorted == true {
                //                    task = concatArray[indexPath.row]
                //                } else {
                //                    task = tasks[indexPath.row]
                //                }
                task = currentArray[indexPath.row]
                // assign the item for the next view
                addTaskViewController.task = task
                // if indexPath is passed, assign the indexPath as well
                addTaskViewController.indexPath = indexPath
                print("editing task")
                // if we click on the add button
            } else {
                // set the destination view controller
                let nC = segue.destination as! UINavigationController
                // tell the destination view controller to communicate with this one
                let addTaskViewController = nC.topViewController as! AddTaskViewController
                addTaskViewController.addTaskDelegate = self
                print ("add new task")
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
        print("check icon pressed from Main VC")
        
        taskID = sender.accessibilityIdentifier
        print(taskID!)
        var check: Bool?
        for task in currentArray {
            if String(describing: task.objectID) == taskID! {
                print(task.title!)
                print(task.isComplete)
                //                let status = task.isComplete
                //                task.isComplete = status
                //                if task.isComplete != true {
                //                    task.isComplete = true
                //                    print(task.isComplete)
                //                } else {
                //                    task.isComplete = false
                //                    print(task.isComplete)
                //                }
                do {
                    try context.save()
                    print ("context.saved!")
                } catch {
                    print("\(error)")
                }
                if task.isComplete == true {
                    if completedTasks.count > 0 {
                        for t in completedTasks {
                            print("printing t...", t)
                            if t == task {
                                check = false
                            } else {
                                check = true
                            }
                        }
                    } else {
                        print("wooooooo all bout dat Else life")
                        completedTasks.append(task)
                    }
                    if check == true {
                        //                        for t in completedTasks {
                        //                            if t != task {
                        completedTasks.append(task)
                        print("just appended to completedTasks!")
                        //                            }
                        //                        }
                    }
                } else {
                    var indexToRemove = 0
                    if completedTasks.count > 0 {
                        for t in completedTasks {
                            if t == task {
                                if indexToRemove < completedTasks.count {
                                    completedTasks.remove(at: indexToRemove)
                                    print("just removed completed task!")
                                } else {
                                    print("====this seems to be where I was getting the index errors====")
                                }
                            }
                            indexToRemove += 1
                        }
                    } else {
                        print("something else went wrong...")
                    }
                }
                //                determineCurrentArray()
                tableView.reloadData()
                dismiss(animated: true, completion: nil)
            }
        }
        print("completedTasks: ", completedTasks)
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
                    //                    currentArray = completedTasks
                    determineCurrentArray()
                    print("***************** back in sortButtonPressed() -- ran determineCurrentArray() -- currentArray is now: ", currentArray)
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
                    //                    getAll()
                    showSorted = false
                    sortBy = ""
                    //                    currentArray = tasks // may have to change this...
                    // RESET completedTasks
                    completedTasks = [Task]()
                    determineCurrentArray()
                    tableView.reloadData()
                    sortCompletedButton.layer.opacity = 0.4
                    print("completed tasks again... ", completedTasks)
                }
            }
        } else if tag == 1 {
            //
            //            var check = 0
            //            for task in tasks {
            //                if task.priority > 0 {
            //                    check += 1
            //                }
            //            }
            if sortOrderPriority == 0 {
                sortOrderPriority = 1
            } else if sortOrderPriority == 1 {
                sortOrderPriority = 2
            } else if sortOrderPriority == 2 {
                sortOrderPriority = 0
            }
            print(sortOrderPriority!)
            
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
                //                if sortPriorityButton.layer.opacity == 0.4 {
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
                //                }
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
            print(sortOrderType!)
            
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
                //                if sortPriorityButton.layer.opacity == 0.4 {
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
                //                }
            } else {
                showSorted = false
                sortBy = ""
                determineCurrentArray()
                tableView.reloadData()
                sortTypeButton.layer.opacity = 0.4
            }
            
            
            
            //            if sortTypeButton.layer.opacity == 0.4 {
            //                sortTypeButton.layer.opacity = 1
            //                if sortPriorityButton.layer.opacity == 1 {
            //                    sortPriorityButton.layer.opacity = 0.4
            //                }
            //                if sortCompletedButton.layer.opacity == 1 {
            //                    sortCompletedButton.layer.opacity = 0.4
            //                }
            //            } else {
            //                sortTypeButton.layer.opacity = 0.4
            //            }
        }
        
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        // if todayButton is inactive, turn it on
        // turn off tomorrow button whether or not it's off
        // deactivate dateToggleButton
        // make sure showSorted is false
        if todayButton.layer.opacity == 0.4 {
            todayButtonOn = true
            tomorrowButtonOn = false
            todayButton.layer.opacity = 1
            tomorrowButton.layer.opacity = 0.4
//            dateToggleButton.layer.opacity = 0.4
            showSorted = false
            determineCurrentArray()
            tableView.reloadData()
        } else { // else we are turning it off
            todayButtonOn = false
            // no need to touch the tomorrowButton
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
//            dateToggleButton.layer.opacity = 0.4
            showSorted = false
            determineCurrentArray()
            tableView.reloadData()
        } else { // else we are turning it off
            tomorrowButtonOn = false
            // no need to touch the todayButton
            tomorrowButton.layer.opacity = 0.4
            determineCurrentArray()
            tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func dateToggleButtonPressed(_ sender: UIButton) {
        print("dateMode at start of dateToggleButtonPressed()", dateMode)
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
        //        getAll()
        determineCurrentArray()
        
        showSorted = false
        //        if sortOrder == nil {
        sortOrderPriority = 2
        sortOrderType = 2
        print("initial sortOrderPriority: ", sortOrderPriority)
        print("initial sortOrderType: ", sortOrderType)
        //        }
        //        tableView.register(TaskCell.self, forCellReuseIdentifier: "tableCell")
        
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
