//
//  TasksList.swift
//  StudentApp
//
//  Created by Егор Ермин on 12.01.2021.
//

import Foundation

protocol TasksSelector {
    func getDebt() -> [Task?]
    func getRealTasks() -> [Task?]
}

struct TasksList: Codable {
    let status: Bool
    let message: String
    let data: List?
}

struct List: Codable {
    let tasks: [Task?]
    let completedTasks: [Task?]
}

struct Task: Codable {
    let id: Int
    let title: String
    let description: String
    let photo: String?
    let test: Test?
    let begin: String
    let deadline: String
}

struct Test: Codable { }

extension List: TasksSelector {
    func getDebt() -> [Task?] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let debt = self.tasks.filter({
            if let stringDate = $0?.deadline,
               let deadlineDate = formatter.date(from: stringDate) {
                return deadlineDate < date
            }
            return false
        })
        
        return debt
    }
    
    func getRealTasks() -> [Task?] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let realTasks = self.tasks.filter({
            if let stringDate = $0?.deadline,
               let deadlineDate = formatter.date(from: stringDate) {
                return deadlineDate > date
            }
            return false
        })
        
        return realTasks
    }
}
