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
    
    private enum URI: String {
        case authorization
        case profileInfo
    }
    
    private let baseUrl = "https://localhost"
    
    // MARK: - Singleton
    static let shared: ServerManager = { return ServerManager() }()
    
    private init() { }
    
    // MARK: - Methods
    func authorization(responseHandler: @escaping handler) {
        
    }
    
    func fetchProfile(responseHandler: @escaping handler) {
        
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
