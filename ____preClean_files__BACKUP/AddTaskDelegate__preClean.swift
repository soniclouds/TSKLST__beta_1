//
//  AddTaskDelegate.swift
//  TSKLIST__1
//
//  Created by soniclouds on 3/15/17.
//  Copyright © 2017 soniclouds. All rights reserved.
//

import Foundation

protocol AddTaskDelegate: class {
    // handle add
    //    func itemSaved(by controller: AddTaskViewController, with title: String, with details: String, with type: String, with priority: Int16, with isComplete: Bool, with time: NSDate, with date: NSDate, at indexPath: NSIndexPath?)
    //
    func itemSaved(by controller: AddTaskViewController, with title: String, with details: String, with type: String, with priority: Int16, with date: NSDate, at indexPath: NSIndexPath?)
    
    
    //    func taskChecked(by controller: MainTableViewController, with isComplete: Bool, at indexPath: NSIndexPath?)
}
