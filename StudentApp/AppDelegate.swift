//
//  AppDelegate.swift
//  StudentApp
//
//  Created by Егор Ермин on 25.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard AccountManager.shared.isUserAuthorized else {
            return true
        }
        
        visitApp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "mainTabBar")

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    private func visitApp() {
        ServerManager.shared.visitApp(responseHandler: { _, _, _ in })
    }
    
}

