//
//  ViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 25.12.2020.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    // MARK: - Business logic and Network
    private func fetchAuthToken() {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        ServerManager.shared.authorization(login: login, password: password, responseHandler: { [weak self] (isSuccess, statusCode, data) in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
            guard isSuccess,
                  let data = data else {
                self?.showAlert(code: statusCode)
                return
            }
            
            guard let token = try? JSONDecoder().decode(Token.self, from: data) else { return }
            
            AccountManager.shared.setAuthToken(token: token.token)
            
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: "main", sender: nil)
            }
        })
    }
    
    private func showAlert(code: Int) {
        let message = "Авторизация не удалась"
        let alert = UIAlertController(title: "\(code)", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    // MARK: - Actions
    @IBAction private func login(_ sender: Any) {
        fetchAuthToken()
    }
    
}

// MARK: - Extensions
extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

