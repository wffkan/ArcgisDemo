//
//  AppDelegate.swift
//  Test
//
//  Created by benny wang on 2020/12/20.
//

import UIKit
import ArcGIS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        window?.rootViewController = BaseEarthViewController()
        ///arcgis初始化，license可以自行到arcgis官网免费注册
        do {
            try AGSArcGISRuntimeEnvironment.setLicenseKey("runtimelite,1000,rud4759932410,none,8SH93PJPXJK5LMZ59251")
        } catch {
            print("-------")
        }
        
        return true
    }
}

