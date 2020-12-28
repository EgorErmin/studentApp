//
//  NetworkHelper.swift
//  StudentApp
//
//  Created by Егор Ермин on 26.12.2020.
//

import Foundation
import Alamofire

class ServerManager {
    
    typealias handler = (Bool, Int?, Any?) -> ()
    
    private enum URN: String {
        case authorization
        case profileInfo
    }
    
    private enum RequestType {
        case post
        case get
        case update
        case delete
    }
    
    private let baseUrl = "https://localhost"
    
    // MARK: - Singleton
    static let shared: ServerManager = { return ServerManager() }()
    
    private init() { }
    
    private func request(type: RequestType, urn: URN, completionHandler: @escaping handler) {
        let fullUri = baseUrl + urn.rawValue
        var request: DataRequest? = nil
        
        switch type {
        case .get:
            request = AF.request(fullUri, method: .get)
        case .post:
            request = AF.request(fullUri, method: .post)
        default:
            return
        }
        
        if let request = request {
            request.responseData(completionHandler: { response in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else { return }
                let isSuccess = ([200, 204, 304] as Set<Int>).contains(statusCode)
                completionHandler(isSuccess, statusCode, data)
            })
        }
    }
    
    // MARK: - Methods
    func authorization(responseHandler: @escaping handler) {
        request(type: .get,
                urn: .authorization,
                completionHandler: responseHandler)
    }
    
    func fetchProfile(responseHandler: @escaping handler) {
        request(type: .get,
                urn: .profileInfo,
                completionHandler: responseHandler)
    }
    
    func editProfile(responseHandler: @escaping handler) {
        
    }
    
    func fetchSchedule(responseHandler: @escaping handler) {
        
    }
    
    func fetchTasks(responseHandler: @escaping handler) {
        
    }
    
    func sendTask(responseHandler: @escaping handler) {
        
    }
    
    func visitApp() {
        
    }
    
}
