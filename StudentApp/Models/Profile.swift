//
//  Profile.swift
//  StudentApp
//
//  Created by Егор Ермин on 28.12.2020.
//

import Foundation

struct Profile: Codable {
    let firstName: String
    let lastName: String
    let patronymic: String
    let birthday: String
    let department: String
    let faculty: String
    let group: String
    let educationProgram: String
    let avatar: String?
}
