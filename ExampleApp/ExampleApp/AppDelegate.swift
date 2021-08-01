//
//  AppDelegate.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
       self.window?.rootViewController = ViewController()
       self.window?.makeKeyAndVisible()
        return true
    }

}

