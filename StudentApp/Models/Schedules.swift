//
//  Schedules.swift
//  StudentApp
//
//  Created by Егор Ермин on 29.12.2020.
//


struct Schedules: Codable {
    let status: Bool
    let message: String
    let data: [String: [Subject]]
}

struct Subject: Codable {
    let name: String
    let location: String
    let time: String
}

class TransitionToArray {
    
    let days = ["Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
                "Sunday"]
    
    func transform(data: [String: [Subject]]) -> [[Subject]]? {
        var subjects: [[Subject]] = []
        
        for number in 0...data.count - 1 {
            guard let subject = data[days[number]] else { return nil }
            subjects.append(subject)
        }
        
        return subjects
    }
    
}
