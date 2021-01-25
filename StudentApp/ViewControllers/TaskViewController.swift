//
//  TaskViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 12.01.2021.
//

import UIKit

final class TaskViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var beginDateLabel: UILabel!
    @IBOutlet private weak var deadlineDateLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var mainInfoView: UIView! {
        didSet {
            mainInfoView.layer.cornerRadius = 8
            mainInfoView.layer.borderWidth = 1
            mainInfoView.layer.borderColor = UIColor.blue.cgColor
        }
    }
    @IBOutlet private weak var debtLabel: UILabel!
    @IBOutlet private weak var debtView: UIView! {
        didSet {
            debtView.layer.cornerRadius = 8
            debtView.layer.borderWidth = 1
            debtView.layer.backgroundColor = #colorLiteral(red: 0.9956567883, green: 0.7542434335, blue: 0.6758830547, alpha: 1)
            debtView.layer.borderColor = UIColor.red.cgColor
        }
    }
    @IBOutlet private weak var startTestButton: UIButton! {
        didSet {
            startTestButton.layer.borderWidth = 1
            startTestButton.layer.cornerRadius = 10
        }
    }
    
    // For completed task
    @IBOutlet private weak var markLabel: UILabel!
    @IBOutlet private weak var teacherCommentLabel: UILabel!
    @IBOutlet private weak var completedTaskView: UIView! {
        didSet {
            completedTaskView.layer.cornerRadius = 8
            completedTaskView.layer.borderWidth = 1
            completedTaskView.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    private var task: Task?
    
    private var isCompleted: Bool {
        return task?.grade != nil
    }
    
    private var debtDays: Int? {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let stringDate = task?.deadline,
           let deadlineDate = formatter.date(from: stringDate) {
            return Calendar.current.dateComponents([.day], from: deadlineDate, to: date).day
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupInfo()
        
        if isCompleted {
            setupForCompletedTask()
        } else {
            DispatchQueue.main.async {
                if self.completedTaskView != nil { self.completedTaskView.removeFromSuperview() }
                self.startTestButton.isHidden = false
            }
            setupDebtNumber()
        }
        
    }
    
    // MARK: - Business logic and Network
    func setTask(task: Task) {
        self.task = task
    }
    
    private func setupInfo() {
        guard let currentTask = task else { return }
        
        DispatchQueue.main.async {
            self.titleLabel.text = currentTask.title
            self.descriptionLabel.text = currentTask.description
            self.beginDateLabel.text = currentTask.begin
            self.deadlineDateLabel.text = currentTask.deadline
        }
        
        if let imagePath = currentTask.photo,
           let photoUrl = URL(string: imagePath) {
            DispatchQueue.main.async {
                self.photoImageView.kf.setImage(with: photoUrl)
            }
        }
    }
    
    private func setupForCompletedTask() {
        if let grade = task?.grade {
            DispatchQueue.main.async {
                self.markLabel.text = "\(grade)"
            }
        }
        if let comment = task?.comment {
            DispatchQueue.main.async {
                self.teacherCommentLabel.text = comment
            }
        }
        DispatchQueue.main.async {
            self.completedTaskView.isHidden = false
        }
    }
    
    private func setupDebtNumber() {
        guard let number = debtDays else {
            DispatchQueue.main.async {
                self.debtView.removeFromSuperview()
            }
            return
        }
        DispatchQueue.main.async {
            self.debtLabel.text = "Вы просрочили выполнение задания на \(number) дней(я). Для получения оценки за семестр необходимо сдать все задания. Пройдите его как можно быстрее."
            self.debtView.isHidden = false
        }
    }
    
    // MARK: - Avtions
    @IBAction private func start(_ sender: Any?) {
        self.performSegue(withIdentifier: "test", sender: nil)
    }
    
    @IBAction private func back(_ sender: Any?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test",
           let taskVC = segue.destination as? TestViewController {
            taskVC.test = task?.test
            taskVC.taskId = task?.id
        }
    }
    
}
