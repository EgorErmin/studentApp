//
//  Schedules.swift
//  StudentApp
//
//  Created by Егор Ермин on 29.12.2020.
//

struct Schedules: Codable {
    let status: Bool
    let message: String
    let data: [Day?]
}

struct Day: Codable {
    let day: String
    let subjects: [Subject?]
}

struct Subject: Codable {
    let name: String
    let location: String
    let time: String
}
