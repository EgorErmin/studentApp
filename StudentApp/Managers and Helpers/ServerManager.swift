//
//  NetworkHelper.swift
//  StudentApp
//
//  Created by Егор Ермин on 26.12.2020.
//

import Foundation
import Alamofire

class ServerManager {
    
    typealias handler = (Bool, Int, Data?) -> ()
    
    private enum URN: String {
        case authorization = "/student/login"
        case profileInfo = "/student/get_profile"
        case visit
    }
    
    private enum RequestType {
        case post
        case get
        case update
        case delete
    }
    
    private let baseUrl = "http://127.0.0.1:3000"
    
    // MARK: - Singleton
    static let shared: ServerManager = { return ServerManager() }()
    
    private init() { }
    
    private func request(type: RequestType,
                         urn: URN,
                         parameters: [String : Any]? = [:],
                         completionHandler: @escaping handler) {
        
        let fullUri = baseUrl + urn.rawValue
        var request: DataRequest? = nil
        
        switch type {
        case .get:
            request = AF.request(fullUri, method: .get, parameters: parameters)
        case .post:
            request = AF.request(fullUri, method: .post, parameters: parameters)
        default:
            return
        }
        
        if let request = request {
            request.responseData(completionHandler: { response in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else {
                    completionHandler(false, 0, nil)
                    return
                }
                let isSuccess = ([200, 204, 304] as Set<Int>).contains(statusCode)
                completionHandler(isSuccess, statusCode, data)
            })
        } else {
            completionHandler(false, 404, nil)
        }
    }
    
    // MARK: - Methods
    func authorization(login: String, password: String, responseHandler: @escaping handler) {
        request(type: .post,
                urn: .authorization,
                parameters: [
                    "login": login,
                    "password": password
                ],
                completionHandler: responseHandler)
    }
    
    func fetchProfile(responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .get,
                urn: .profileInfo,
                parameters: [
                    "secret_token": token
                ],
                completionHandler: responseHandler)
    }
    
//    func editProfile(responseHandler: @escaping handler) {
//        request(type: .post,
//                urn: <#T##URN#>,
//                completionHandler: responseHandler)
//    }
//
//    func fetchSchedule(responseHandler: @escaping handler) {
//        request(type: .get,
//                urn: <#T##URN#>,
//                completionHandler: responseHandler)
//    }
//
//    func fetchTasks(responseHandler: @escaping handler) {
//        request(type: .get,
//                urn: <#T##URN#>,
//                completionHandler: responseHandler)
//    }
//
//    func sendTask(responseHandler: @escaping handler) {
//        request(type: .post,
//                urn: <#T##URN#>,
//                completionHandler: responseHandler)
//    }
    
    func visitApp(responseHandler: @escaping handler) {
        request(type: .post,
                urn: .visit,
                completionHandler: responseHandler)
    }
    
}
