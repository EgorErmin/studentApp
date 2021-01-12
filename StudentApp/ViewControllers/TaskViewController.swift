//
//  TaskViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 12.01.2021.
//

import UIKit

class TaskViewController: UIViewController {

    private var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Business logic and Network
    func setTask(task: Task) {
        self.task = task
    }
    
}
