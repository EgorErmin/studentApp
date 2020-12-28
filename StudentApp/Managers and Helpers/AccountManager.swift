//
//  AccountManager.swift
//  StudentApp
//
//  Created by Егор Ермин on 28.12.2020.
//

import KeychainAccess

class AccountManager {
    
    // MARK: - Singleton
    static let shared: AccountManager = { return AccountManager() }()
    
    private init() { }
    
    var authToken: String? { return try? Keychain().getString("authorizationToken") }

    var isUserAuthorized: Bool { return authToken != nil }
    
    func setAuthToken(token: String) {
        try? Keychain().set(token, key: "authorizationToken")
    }
    
}
