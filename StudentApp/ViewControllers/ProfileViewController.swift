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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileInfo()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(editAvatar(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Business logic and Network
    private func fetchProfileInfo() {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        ServerManager.shared.fetchProfile(responseHandler: { [weak self] (isSuccess, statusCode, data) in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
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
        
        if let avatarPath = profile.photo {
            let fullPath = ServerManager.shared.getPhotoPath(URN: avatarPath)
            let avatarUrl = URL(string: fullPath)
            DispatchQueue.main.async {
                self.avatarImageView.kf.setImage(with: avatarUrl)
            }
        }
    }
    
    @objc private func editAvatar(tapGestureRecognizer: UITapGestureRecognizer) {
        let imageVC = UIImagePickerController()
        imageVC.sourceType = .photoLibrary
        imageVC.allowsEditing = true
        imageVC.delegate = self
        
        DispatchQueue.main.async {
            self.present(imageVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    @IBAction private func edit(_ sender: Any) {
        
    }
    
    @IBAction private func logout(_ sender: Any) {
        AccountManager.shared.deleteAuthToken()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else {
            return
        }
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let authVC = stb.instantiateViewController(withIdentifier: "authVC")
        
        window.rootViewController = authVC
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion:  nil)
        
        guard let image = info[.editedImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 1) else { return }
        
        ServerManager.shared.editAvatar(data: data, responseHandler: { [weak self] (isSuccess, statusCode, data) in
            
            guard isSuccess else { return }
            
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
            
        })
        
    }
    
}
