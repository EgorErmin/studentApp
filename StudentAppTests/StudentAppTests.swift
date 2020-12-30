//
//  StudentAppTests.swift
//  StudentAppTests
//
//  Created by Егор Ермин on 25.12.2020.
//

import XCTest
@testable import StudentApp

class StudentAppTests: XCTestCase {

    var serverManager: ServerManager?
    var transToArr: TransitionToArray?
    
    override func setUpWithError() throws {
        serverManager = ServerManager()
        transToArr = TransitionToArray()
    }

    override func tearDownWithError() throws {
        serverManager = nil
        transToArr = nil
    }

    func testAsyncRequestLoginWithIncorrectData() throws {
        
        // Given
        let login = "123"
        let password = "123"
        let expectedResult = false
        var workResult: Bool?
        
        let validatorExpectation = expectation(description: "Expectation in " + #function)
        
        // When
        serverManager?.authorization(login: login, password: password, responseHandler: { (isSuccess, responseCode, _) in
            
            workResult = isSuccess
            
            validatorExpectation.fulfill()
        })
        
        // Then
        waitForExpectations(timeout: 2.0, handler: { error in
            
            if error != nil {
                XCTFail()
            }
            
            XCTAssertEqual(expectedResult, workResult)
        })
    }
    
    func testAsyncRequestLoginWithCorrectData() throws {
        
        // Given
        let login = "s1012"
        let password = "npndtvmulczybuhnvikcfufahldkfbly"
        let expectedResult = true
        var workResult: Bool?
        
        let validatorExpectation = expectation(description: "Expectation in " + #function)
        
        // When
        serverManager?.authorization(login: login, password: password, responseHandler: { (isSuccess, responseCode, _) in
            
            workResult = isSuccess
            
            validatorExpectation.fulfill()
        })
        
        // Then
        waitForExpectations(timeout: 2.0, handler: { error in
            
            if error != nil {
                XCTFail()
            }
            
            XCTAssertEqual(expectedResult, workResult)
        })
    }
    
    func testTransitionToArraySchedulesWithCorrectData() throws {
        let expectedResult = true
        let workResult: Bool?
        
        let schedule: [String: [Subject]] = [
            "Monday": [Subject(name: "Maths", location: "123", time: "8:00")],
            "Tuesday": [Subject(name: "Maths", location: "123", time: "8:00")],
            "Wednesday": [Subject(name: "Draw", location: "321", time: "10:00")]
        ]
        
        if transToArr?.transform(data: schedule) != nil {
            workResult = true
        } else {
            workResult = false
        }
        
        XCTAssertEqual(expectedResult, workResult)
    }
    
    func testTransitionToArraySchedulesWithIncorrectData() throws {
        let expectedResult = false
        let workResult: Bool?
        
        let schedule: [String: [Subject]] = [
            "Monday": [Subject(name: "Maths", location: "123", time: "8:00")],
            "Wensday": [Subject(name: "Draw", location: "321", time: "10:00")],
            "Wensday123": [Subject(name: "Draw", location: "321", time: "10:00")]
        ]
        
        if transToArr?.transform(data: schedule) != nil {
            workResult = true
        } else {
            workResult = false
        }
        
        XCTAssertEqual(expectedResult, workResult)
    }

}
