//
//  ScheduleViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 26.12.2020.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var scheduleTableView: UITableView!
    
    var subjects: [[Subject]]? = nil
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSchedule(completion: { [weak self] result in
            self?.subjects = TransitionToArray().transform(data: result.data)
            DispatchQueue.main.async {
                self?.scheduleTableView.reloadData()
            }
        })
    }
    
    // MARK: - Business logic and Network
    private func fetchSchedule(completion: ((Schedules) -> ())?) {
        
        ServerManager.shared.fetchSchedule(responseHandler: { (isSuccess, statusCode, data) in
            
            guard isSuccess,
                  let data = data else { return }
            
            guard let schedule = try? JSONDecoder().decode(Schedules.self, from: data) else { return }
            
            completion?(schedule)
        })
        
    }

}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        subjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Понедельник"
        case 1: return "Вторник"
        case 2: return "Среда"
        case 3: return "Четверг"
        case 4: return "Пятница"
        case 5: return "Суббота"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subjects?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectTableViewCell
        guard let day = subjects?[indexPath.section] else { return cell }
        let subject = day[indexPath.row]
        cell.setup(subject: subject, number: indexPath.row + 1)
        return cell
    }
    
    
}
