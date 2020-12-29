//
//  SubjectTableViewCell.swift
//  StudentApp
//
//  Created by Егор Ермин on 29.12.2020.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    func setup(subject: Subject, number: Int) {
        DispatchQueue.main.async {
            self.nameLabel.text = subject.name
            self.locationLabel.text = subject.location
            self.timeLabel.text = subject.time
            self.numberLabel.text = "\(number))"
        }
    }
    
}
