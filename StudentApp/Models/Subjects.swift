//
//  Subjects.swift
//  StudentApp
//
//  Created by Егор Ермин on 12.01.2021.
//

import Foundation

struct Subjects: Codable {
    let status: Bool
    let error: String
    let data: [OneSubject?]
}

struct OneSubject: Codable {
    let subjectId: Int
    let name: String
}
