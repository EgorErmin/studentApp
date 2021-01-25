//
//  TimeHelper.swift
//  StudentApp
//
//  Created by Егор Ермин on 26.01.2021.
//

import UIKit

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
