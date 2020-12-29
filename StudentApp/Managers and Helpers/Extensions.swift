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
    case 400, 500:
      return "ОШИБКА ПРИ ОБРАБОТКЕ ЗАПРОСА"
    default:
      return "ОШИБКА"
    }
  }
}

extension UIViewController {
    
    func showErrorResponse(code: ErrorResponse, message: String) {
        let title = "\(code.code): " + code.title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
}
