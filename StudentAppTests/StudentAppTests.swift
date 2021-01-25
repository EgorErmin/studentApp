//
//  StudentAppTests.swift
//  StudentAppTests
//
//  Created by Егор Ермин on 25.12.2020.
//

import XCTest
@testable import StudentApp

class StudentAppTests: XCTestCase {
    
    var timeHelper: TimeHepler?
    
    override func setUpWithError() throws {
        timeHelper = TimeHepler()
    }

    override func tearDownWithError() throws {
        timeHelper = nil
    }
    
    func testTransferInSecondsWithCorrectData() throws {
        let expectedResult = true
        let goodValue = 360
        
        let workResult = timeHelper?.transferInSeconds(minutes: 6) == goodValue
        
        XCTAssertEqual(expectedResult, workResult)
    }
    
    func testSetTimeWithCorrectData() throws {
        let expectedResult = true
        let label = UILabel()
        
        let validatorExpectation = expectation(description: "Expectation in " + #function)
        
        timeHelper?.setTime(timeInSec: 120, label: label)
        var workResult = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            workResult = label.text == "2:0"
            validatorExpectation.fulfill()
        })

        waitForExpectations(timeout: 3.0, handler: { error in

            if error != nil {
                XCTFail()
            }

            XCTAssertEqual(expectedResult, workResult)
        })
        
    }
    
//    func testAsyncRequestLoginWithIncorrectData() throws {
//
//        // Given
//        let login = "123"
//        let password = "123"
//        let expectedResult = false
//        var workResult: Bool?
//
//        let validatorExpectation = expectation(description: "Expectation in " + #function)
//
//        // When
//        serverManager?.authorization(login: login, password: password, responseHandler: { (isSuccess, responseCode, _) in
//
//            workResult = isSuccess
//
//            validatorExpectation.fulfill()
//        })
//
//        // Then
//        waitForExpectations(timeout: 2.0, handler: { error in
//
//            if error != nil {
//                XCTFail()
//            }
//
//            XCTAssertEqual(expectedResult, workResult)
//        })
//    }
//
//    func testAsyncRequestLoginWithCorrectData() throws {
//
//        // Given
//        let login = "s1012"
//        let password = "npndtvmulczybuhnvikcfufahldkfbly"
//        let expectedResult = true
//        var workResult: Bool?
//
//        let validatorExpectation = expectation(description: "Expectation in " + #function)
//
//        // When
//        serverManager?.authorization(login: login, password: password, responseHandler: { (isSuccess, responseCode, _) in
//
//            workResult = isSuccess
//
//            validatorExpectation.fulfill()
//        })
//
//        // Then
//        waitForExpectations(timeout: 2.0, handler: { error in
//
//            if error != nil {
//                XCTFail()
//            }
//
//            XCTAssertEqual(expectedResult, workResult)
//        })
//    }
//
//    func testTransitionToArraySchedulesWithCorrectData() throws {
//        let expectedResult = true
//        let workResult: Bool?
//
//        let schedule: [String: [Subject]] = [
//            "Monday": [Subject(name: "Maths", location: "123", time: "8:00")],
//            "Tuesday": [Subject(name: "Maths", location: "123", time: "8:00")],
//            "Wednesday": [Subject(name: "Draw", location: "321", time: "10:00")]
//        ]
//
//        if transToArr?.transform(data: schedule) != nil {
//            workResult = true
//        } else {
//            workResult = false
//        }
//
//        XCTAssertEqual(expectedResult, workResult)
//    }
//
//    func testTransitionToArraySchedulesWithIncorrectData() throws {
//        let expectedResult = false
//        let workResult: Bool?
//
//        let schedule: [String: [Subject]] = [
//            "Monday": [Subject(name: "Maths", location: "123", time: "8:00")],
//            "Wensday": [Subject(name: "Draw", location: "321", time: "10:00")],
//            "Wensday123": [Subject(name: "Draw", location: "321", time: "10:00")]
//        ]
//
//        if transToArr?.transform(data: schedule) != nil {
//            workResult = true
//        } else {
//            workResult = false
//        }
//
//        XCTAssertEqual(expectedResult, workResult)
//    }

}
