//
//  TasksListTableViewCell.swift
//  StudentApp
//
//  Created by Егор Ермин on 12.01.2021.
//

import UIKit

class TasksListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    func setup(title: String, startDate: String, deadline: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = title
            self.startDateLabel.text = startDate
            self.deadlineLabel.text = deadline
        }
    }
    
}
