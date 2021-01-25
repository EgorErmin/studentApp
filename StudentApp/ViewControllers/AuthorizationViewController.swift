//
//  ViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 25.12.2020.
//

import UIKit

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        DispatchQueue.main.async { [weak self] in
            self?.loginTextField.text?.removeAll()
            self?.passwordTextField.text?.removeAll()
        }
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
                let message = "К сожалению вы не смогли авторизоваться, повторите попытку позже или введите другие данные"
                self?.showErrorResponse(code: ErrorResponse(code: statusCode),
                                        message: message,
                                        completion: nil)
                return
            }
            
            guard let token = try? JSONDecoder().decode(Token.self, from: data) else { return }
            
            AccountManager.shared.setAuthToken(token: token.token)
            
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: "main", sender: nil)
            }
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

