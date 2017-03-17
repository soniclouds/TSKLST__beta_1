//
//  TaskCell.swift
//  TSKLIST__1
//
//  Created by soniclouds on 3/15/17.
//  Copyright © 2017 soniclouds. All rights reserved.
//

import UIKit
import CoreData

class TaskCell: UITableViewCell {
    
    var task: Task?
    var isChecked: Bool?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    
    @IBOutlet weak var typeIconButton: UIButton!
    @IBOutlet weak var checkIconButton: UIButton!
    
    @IBOutlet weak var detailsTopConstraint: NSLayoutConstraint!

    @IBAction func checkIconButtonPressed(_ sender: UIButton) {
        if self.isChecked != true {
            self.isChecked = true
            self.task?.isComplete = true
            checkIconButton.setTitleColor(UIColor.white, for: .normal)
            self.backgroundColor = UIColor.green
        } else {
            self.isChecked = false
            self.task?.isComplete = false
            checkIconButton.setTitleColor(UIColor.lightGray, for: .normal)
            self.backgroundColor = UIColor.clear
        }
    }

}
