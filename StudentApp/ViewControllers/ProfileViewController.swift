//
//  MainViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 25.12.2020.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var departmentLabel: UILabel!
    @IBOutlet private weak var facultyLabel: UILabel!
    @IBOutlet private weak var groupLabel: UILabel!
    @IBOutlet private weak var educationProgramLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Business logic
    
    
    // MARK: - Actions
    @IBAction private func edit(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
