//
//  TasksViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 26.12.2020.
//

import UIKit

class TasksListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var subjectsPickerView: UIPickerView!
    @IBOutlet private weak var tasksTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var subjects = [OneSubject?]()
    private var tasks = [Task?]()
    private var debt = [Task?]()
    private var completedTask = [Task?]()
    private var selectedSubjectId: Int? = nil
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSubjects()
    }
    
    // MARK: - Business logic and Network
    private func fetchSubjects() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        ServerManager.shared.getSubjects(responseHandler: { [weak self] (isSuccess, responseCode, response) in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
            guard isSuccess,
                  let data = response,
                  let subjects = try? JSONDecoder().decode(Subjects.self, from: data) else {
                return
            }
            
            self?.subjects = subjects.data
            self?.setupPickerView()
        })
    }
    
    private func fetchTasks() {
        guard let id = selectedSubjectId else { return }
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        ServerManager.shared.fetchTasks(subjectId: id, responseHandler: { [weak self] (isSuccess, responseCode, response) in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
            guard isSuccess,
                  let data = response,
                  let tasks = try? JSONDecoder().decode(TasksList.self, from: data),
                  let tasksData = tasks.data else {
                return
            }
        
            self?.completedTask = tasksData.completedTasks
            self?.debt = tasksData.getDebt()
            self?.tasks = tasksData.getRealTasks()
            
            DispatchQueue.main.async {
                self?.tasksTableView.reloadData()
            }
        })
    }
    
    private func setupPickerView() {
        DispatchQueue.main.async {
            self.subjectsPickerView.reloadAllComponents()
            let numberRow = self.subjects.count / 2
            self.subjectsPickerView.selectRow(numberRow, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "task",
           let taskVC = segue.destination as? TaskViewController,
           let task = sender as? Task {
            taskVC.setTask(task: task)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension TasksListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Текущие задания (Всего: \(tasks.count))"
        case 1: return "Задолженности (Всего: \(debt.count))"
        case 2: return "Выполненные задания (Всего: \(completedTask.count))"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return tasks.count
        case 1: return debt.count
        case 2: return completedTask.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksListCell", for: indexPath) as! TasksListTableViewCell
        let row = indexPath.row
        switch indexPath.section {
        case 0:
            guard let task = tasks[row] else { return cell }
            cell.setup(title: task.title,
                       startDate: task.begin,
                       deadline: task.deadline)
        case 1:
            guard let debt = debt[row] else { return cell }
            cell.setup(title: debt.title,
                       startDate: debt.begin,
                       deadline: debt.deadline)
        case 2:
            guard let completedTask = completedTask[row] else { return cell }
            cell.setup(title: completedTask.title,
                       startDate: completedTask.begin,
                       deadline: completedTask.deadline)
        default: print()
        }
        return cell
    }

}

// MARK: - UITableViewDelegate
extension TasksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            switch section {
            case 0: headerView.contentView.backgroundColor = #colorLiteral(red: 0.8110570312, green: 0.9306610823, blue: 1, alpha: 1)
            case 1: headerView.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4724795818, blue: 0.4304271936, alpha: 1)
            case 2: headerView.contentView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            default: headerView.contentView.backgroundColor = .white
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch indexPath.section {
        case 0:
            guard let task = tasks[row] else { return }
            self.performSegue(withIdentifier: "task", sender: task)
        case 1:
            guard let debt = debt[row] else { return }
            self.performSegue(withIdentifier: "task", sender: debt)
        case 2:
            guard let completedTask = completedTask[row] else { return }
            self.performSegue(withIdentifier: "task", sender: completedTask)
        default: print()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension TasksListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let subject = subjects[row] else { return "unavalible" }
        return subject.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let subject = subjects[row] else { return }
        selectedSubjectId = subject.subjectId
        fetchTasks()
    }
}
