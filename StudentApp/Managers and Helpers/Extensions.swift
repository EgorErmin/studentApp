//
//  Extensions.swift
//  StudentApp
//
//  Created by Егор Ермин on 29.12.2020.
//

import UIKit

struct ErrorResponse {
    let code: Int
    var title: String {
        switch code {
        case 404:
            return "СТРАНИЦА НЕ НАЙДЕНА"
        case 401:
            return "ПОЛЬЗОВАТЕЛЬ НЕ АВТОРИЗОВАН"
        case 400, 500:
            return "СЕРВЕР НЕ СМОГ ОБРАБОТАТЬ ЗАПРОС"
        default:
            return "ОШИБКА"
        }
    }
}

extension UIViewController {
    
    func showErrorResponse(code: ErrorResponse, message: String, completion: (() -> ())?) {
        let title = "\(code.code): " + code.title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.dismiss(animated: true, completion: nil)
                completion?()
            })
        })
    }
    
    func showAllertWithMessage(message: String, completion: (() -> ())?) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.dismiss(animated: true, completion: nil)
                completion?()
            })
        })
    }
    
    func showAllertDialog(message: String, completion: (() -> ())?) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
