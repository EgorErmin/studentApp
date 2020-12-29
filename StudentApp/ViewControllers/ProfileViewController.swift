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
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.clipsToBounds = true
            avatarImageView.layer.borderWidth = 1
            avatarImageView.layer.borderColor = UIColor.blue.cgColor
        }
    }
    @IBOutlet weak var infoView: UIView! {
        didSet {
            infoView.layer.cornerRadius = 8
            infoView.layer.borderWidth = 1
            infoView.layer.borderColor = UIColor.blue.cgColor
        }
    }
    @IBOutlet weak var buttonsView: UIView! {
        didSet {
            buttonsView.layer.cornerRadius = 8
            buttonsView.layer.borderWidth = 1
            buttonsView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileInfo()
    }
    
    // MARK: - Business logic and Network
    private func fetchProfileInfo() {
        
        ServerManager.shared.fetchProfile(responseHandler: { [weak self] (isSuccess, statusCode, data) in
            
            guard isSuccess,
                  let data = data else { return }
            
            guard let profile = try? JSONDecoder().decode(Profile.self, from: data) else { return }
            
            self?.setupProfileInfo(profile: profile)
        })
        
    }
    
    private func setupProfileInfo(profile: Profile) {
        DispatchQueue.main.async {
            self.fullNameLabel.text = profile.firstName + " " + profile.lastName + " " + profile.patronymic
            self.birthdayLabel.text = profile.dateOfBirth
            self.groupLabel.text = profile.groupName
            self.departmentLabel.text = profile.departmentName
            self.facultyLabel.text = profile.facultyName
            self.educationProgramLabel.text = profile.educationProgramName
        }
    }
    
    // MARK: - Actions
    @IBAction private func edit(_ sender: Any) {
        
    }
    
    @IBAction private func logout(_ sender: Any) {
        AccountManager.shared.deleteAuthToken()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
