//
//  EditProfileViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 10.01.2021.
//

import UIKit

final class EditProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordSwitch: UISwitch! {
        didSet {
            passwordSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        }
    }
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.borderWidth = 1
            saveButton.layer.cornerRadius = 10
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Business logic and Network
    @objc private func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    // MARK: - Actions
    @IBAction private func saveChange(_ sender: Any) {
        guard let password = passwordTextField.text,
              !password.isEmpty else {
            self.showAllertWithMessage(message: "Вы не ввели новый пароль", completion: nil)
            return
        }
        ServerManager.shared.editProfile(newPassword: password, responseHandler: { [weak self] (isSuccess, statusCode, response) in
            
            guard isSuccess else {
                self?.showErrorResponse(code: ErrorResponse(code: statusCode),
                                        message: "Не удалось изменить пароль",
                                        completion: {
                                            DispatchQueue.main.async {
                                                self?.dismiss(animated: true, completion: nil)
                                            }
                                        })
                return
            }
            
            self?.showAllertWithMessage(message: "Пароль успешно изменён", completion: {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            
        })
    }
    
    @IBAction private func back() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
