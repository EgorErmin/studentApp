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
