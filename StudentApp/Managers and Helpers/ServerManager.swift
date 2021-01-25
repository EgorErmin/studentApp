//
//  NetworkHelper.swift
//  StudentApp
//
//  Created by Егор Ермин on 26.12.2020.
//

import Alamofire

final class ServerManager {
    
    typealias handler = (Bool, Int, Data?) -> ()
    
    private enum URN: String {
        case authorization = "/student/login"
        case profileInfo = "/student/get_profile"
        case editProfile = "/student/edit"
        case schedules = "/schedule/getmy"
        case editAvatar = "/student/update_photo"
        case tasks = "/task/get"
        case sendGrade = "/task_result/set_grade"
        case subjects = "/subject/student"
        case visit = "/student/visit"
    }
    
    private enum RequestType {
        case post
        case postBody
        case get
        case update
        case delete
    }
    
    //HomeIP: 192.168.1.81
    //WorkIP: 192.168.1.168
    private let baseUrl = "http://192.168.1.81:3000"
    
    // MARK: - Singleton
    static let shared: ServerManager = { return ServerManager() }()
    
    private init() { }
    
    private func request(type: RequestType,
                         urn: String,
                         parameters: [String : Any]? = [:],
                         completionHandler: @escaping handler) {
        
        let fullUri = baseUrl + urn
        var request: DataRequest? = nil
        
        switch type {
        case .get:
            request = AF.request(fullUri, method: .get, parameters: parameters)
        case .post:
            request = AF.request(fullUri, method: .post, parameters: parameters)
        case .postBody:
            request = AF.upload(multipartFormData: { multipartFormData in
                if var params = parameters {
                    for (key, value) in params {
                        if let dataValue = value as? Data {
                            multipartFormData.append(dataValue, withName: key, fileName: key)
                        }
                        params.removeValue(forKey: key)
                    }
                }
            }, to: fullUri)
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
                urn: URN.authorization.rawValue,
                parameters: [
                    "login": login,
                    "password": password
                ],
                completionHandler: responseHandler)
    }
    
    func fetchProfile(responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .get,
                urn: URN.profileInfo.rawValue,
                parameters: [
                    "secret_token": token
                ],
                completionHandler: responseHandler)
    }
    
    func editProfile(newPassword: String, responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .post,
                urn: URN.editProfile.rawValue + "?secret_token=\(token)" + "&password=\(newPassword)",
                completionHandler: responseHandler)
    }

    
    // MARK: - TODO
    func editAvatar(data: Data, responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .postBody,
                urn: URN.editAvatar.rawValue + "?secret_token=\(token)" + "&photo_ext=.jpeg",
                parameters: [
                    "file": data
                ],
                completionHandler: responseHandler)
    }
    
    func fetchSchedule(responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .get,
                urn: URN.schedules.rawValue,
                parameters: [
                    "secret_token": token
                ],
                completionHandler: responseHandler)
    }

    func fetchTasks(subjectId: Int, responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .get,
                urn: URN.tasks.rawValue + "?secret_token=\(token)" + "&subjectId=\(subjectId)",
                completionHandler: responseHandler)
    }
    
    func getSubjects(responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .get,
                urn: URN.subjects.rawValue + "?secret_token=\(token)",
                completionHandler: responseHandler)
    }
    

    func sendGrade(taskId: Int, grade: Int, responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .post,
                urn: URN.sendGrade.rawValue + "?secret_token=\(token)" + "&taskId=\(taskId)" + "&grade=\(grade)",
                completionHandler: responseHandler)
    }
    
    func visitApp(responseHandler: @escaping handler) {
        guard let token = AccountManager.shared.authToken else { return }
        request(type: .post,
                urn: URN.visit.rawValue + "?secret_token=\(token)",
                completionHandler: responseHandler)
    }
    
    func getPhotoPath(URN: String) -> String {
        return baseUrl + URN
    }
    
}
