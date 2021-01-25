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
    let grade: Int?
    let comment: String?
}

struct Test: Codable {
    var testTime: Int
    let resultRequirements: [Result]
    let questions: [Question?]
}

// MARK: - TODO
struct Result: Codable {
    let mark: Int
}

struct Question: Codable {
    let question: String
    let answers: [Answer]
    let correct: Int
}

// MARK: - TODO 
struct Answer: Codable {
    let answer: String
}

extension List: TasksSelector {
    
    private enum TypeTask {
        case debt
        case real
    }
    
    private func selectTask(type: TypeTask) -> [Task?] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let tasks = self.tasks.filter({
            if let stringDate = $0?.deadline,
               let deadlineDate = formatter.date(from: stringDate) {
                switch type {
                case .debt: return deadlineDate < date
                case .real: return deadlineDate > date
                }
            }
            return false
        })
        
        return tasks
    }
    
    func getDebt() -> [Task?] {
        selectTask(type: .debt)
    }
    
    func getRealTasks() -> [Task?] {
        selectTask(type: .real)
    }
    
}
