//
//  AppDelegate.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 28/09/2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppCoordinator.shared.initializeScene()
        return true
    }

}
