//
//  TestTableViewCell.swift
//  StudentApp
//
//  Created by Егор Ермин on 14.01.2021.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton! {
        didSet {
            answerButton.layer.cornerRadius = answerButton.frame.size.width / 2
            answerButton.clipsToBounds = true
            answerButton.layer.borderWidth = 1
            answerButton.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    func removeButtonImage() {
        answerButton.setImage(nil, for: .normal)
    }
    
    func setupAnswerButton() {
        answerButton.setImage(#imageLiteral(resourceName: "check"), for: .normal)
    }
    
    func setup(answer: String) {
        DispatchQueue.main.async {
            self.answerLabel.text = answer
        }
    }
}
