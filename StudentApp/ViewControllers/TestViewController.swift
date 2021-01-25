//
//  TestViewController.swift
//  StudentApp
//
//  Created by Егор Ермин on 14.01.2021.
//

import UIKit

final class TestViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var testTableView: UITableView!
    @IBOutlet private weak var finishButton: UIButton! {
        didSet {
            finishButton.layer.borderWidth = 1
            finishButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: - Properties
    private var timer: Timer? = nil
    private var timeHelper: TimeHelperProtocol?
    
    var taskId: Int? = nil
    var test: Test? = nil
    
    var results = [Int]()
    
    private var isCompleted: Bool?
    
    private var correctGrade: [Int]? {
        guard let test = test else { return nil }
        var correct = [Int]()
        for i in 0...test.questions.count - 1 {
            correct.append(test.questions[i]!.correct)
        }
        return correct
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        timeHelper = TimeHepler()
        guard let testTime = test?.testTime,
              let countAnswer = test?.resultRequirements.count,
              let timeHelper = timeHelper else { return }
        test?.testTime = timeHelper.transferInSeconds(minutes: testTime)
        timeHelper.setTime(timeInSec: test?.testTime ?? 0, label: timeLabel)
        for _ in 0...countAnswer - 1 {
            results.append(-1)
        }
        setupTimer()
    }
    
    // MARK: - Business logic and Network
    private func sendGrade(_ grade: Int, countCorrect: Int) {
        guard let id = taskId else { return }
        ServerManager.shared.sendGrade(taskId: id, grade: grade, responseHandler: { (isSuccess, responseCode, response) in
            guard isSuccess,
                  let data = response else { return }
            
            guard let success = try? JSONDecoder().decode(GradeWork.self, from: data) else { return }
            
            if success.status {
                self.showAllertWithMessage(message: "Тест завершён. Ваша оценка \(grade). Количество правильных ответов: \(countCorrect) из \(self.correctGrade!.count)", completion: {
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                })
            } else {
                self.showAllertWithMessage(message: "Проблемы на стороне сервера. Пересдайте тест позже.", completion: {
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                })
            }
        })
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc private func update() {
        guard let testTime = test?.testTime,
              let timeHelper = timeHelper else { return }
        if testTime == 0 {
            timer?.invalidate()
            timer = nil
            calculateGrade()
            self.timeLabel.text = "0:0"
        } else {
            timeHelper.setTime(timeInSec: testTime, label: timeLabel)
            test?.testTime -= 1
        }
    }
    
    private func putGrade(countGoodAnswers: Int) -> Int {
        guard let test = test else { return 0 }
        let veryGood = test.resultRequirements[2].mark
        let good = test.resultRequirements[1].mark
        let bad = test.resultRequirements[0].mark
        
        switch countGoodAnswers {
        case veryGood: return 5
        case good..<veryGood: return 4
        case bad..<good: return 3
        default: return 0
        }
    }
    
    private func calculateGrade() {
        guard let correct = correctGrade else { return }
        var countGood = 0
        for i in 0...correct.count - 1 {
            if correct[i] == results[i] {
                countGood += 1
            }
        }
        let grade = putGrade(countGoodAnswers: countGood)
        sendGrade(grade, countCorrect: countGood)
    }
    
    // MARK: - Actions
    @IBAction private func finish(_ sender: Any) {
        calculateGrade()
    }
    
}

extension TestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let test = test else { return 0 }
        return test.questions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let test = test else { return "" }
        return test.questions[section]?.question
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let test = test else { return 0 }
        return test.questions[section]?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! TestTableViewCell
        guard let test = test,
              let question = test.questions[indexPath.section] else { return cell }
        let answer = question.answers[indexPath.row].answer
        cell.setup(answer: answer)
        return cell
    }
    
}

extension TestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TestTableViewCell
        cell.setupAnswerButton()
        
        let countRow = tableView.numberOfRows(inSection: indexPath.section)
        for i in 0...countRow - 1 {
            var localIndexPath = indexPath
            localIndexPath.row = i
            let cell = tableView.cellForRow(at: localIndexPath) as! TestTableViewCell
            cell.removeButtonImage()
        }
        
        cell.setupAnswerButton()
        
        results[indexPath.section] = indexPath.row
    }
}

protocol TimeHelperProtocol {
    func setTime(timeInSec: Int, label: UILabel)
    func transferInSeconds(minutes: Int) -> Int
}

class TimeHepler: TimeHelperProtocol {
    func setTime(timeInSec: Int, label: UILabel) {
        let sec = timeInSec % 60
        let min = timeInSec / 60
        DispatchQueue.main.async {
            label.text = "\(min):\(sec)"
        }
    }
    
    func transferInSeconds(minutes: Int) -> Int {
        return minutes * 60
    }
}
