//
//  ViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 25.12.2020.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.borderWidth = 1
            loginButton.layer.cornerRadius = 10
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Business logic
    
    
    
    // MARK: - Actions
    @IBAction private func login(_ sender: Any) {
        performSegue(withIdentifier: "main", sender: nil)
    }
    
}

// MARK: - Extensions
extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

