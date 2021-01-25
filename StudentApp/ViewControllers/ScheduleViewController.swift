//
//  ScheduleViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 26.12.2020.
//

import UIKit

final class ScheduleViewController: UIViewController {

    @IBOutlet private weak var scheduleTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var subjects = [Day?]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSchedule(completion: { [weak self] result in
            self?.subjects = result.data
            DispatchQueue.main.async {
                self?.scheduleTableView.reloadData()
            }
        })
    }
    
    // MARK: - Business logic and Network
    private func fetchSchedule(completion: ((Schedules) -> ())?) {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        ServerManager.shared.fetchSchedule(responseHandler: { [weak self] (isSuccess, statusCode, data) in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
            guard isSuccess,
                  let data = data else { return }
            
            guard let schedule = try? JSONDecoder().decode(Schedules.self, from: data) else { return }
            
            completion?(schedule)
        })
        
    }

}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        subjects.count
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
        subjects[section]?.subjects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectTableViewCell
        guard let day = subjects[indexPath.section]?.subjects,
              let subject = day[indexPath.row] else { return cell }
        cell.setup(subject: subject, number: indexPath.row + 1)
        return cell
    }
    
    
}
