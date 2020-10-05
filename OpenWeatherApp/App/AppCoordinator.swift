//
//  AppCoordinator.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 01/10/2020.
//
import UIKit

final class AppCoordinator: BaseAppCoordinator {
    
    override func setWindowRootViewController() {
        guard let window = window else {
            return
        }
        window.rootViewController = createMainNavigationController()
    }
 
    override func registerViewControllers(builder: ScenesViewControllerBuilder) {
        builder.register(viewControllerType: CurrentWeatherViewController.self, forType: .currentWeather)
    }
    
    private func createMainNavigationController() -> UINavigationController {
        let mainSceneViewController = createMainSceneViewController()
        let mainNavigationController = UINavigationController(rootViewController: mainSceneViewController)
        mainNavigationController.navigationBar.tintColor = UIColor.black
        mainNavigationController.navigationBar.backgroundColor = UIColor.white
        return mainNavigationController
    }
}
