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
    let dateOfBirth: String
    let departmentName: String
    let facultyName: String
    let groupName: String
    let educationProgramName: String
    let photo: String?
}
