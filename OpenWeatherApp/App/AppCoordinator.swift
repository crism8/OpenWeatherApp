//
//  AppCoordinator.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 01/10/2020.
//
import UIKit

protocol SceneBuilderProtocol {
    func createScene(withServiceLocator serviceLocator: ServiceLocator) -> UIViewController
}

final class AppCoordinator {
    // MARK: Variables
    static let shared = {
        return AppCoordinator()
    }()
    
    private let servicesLocator: ServiceLocator
    private var window: UIWindow?
    
    // MARK: Initialization
    private init() {
        servicesLocator = ServiceLocator()
        registerServices()
    }

    private func registerServices() {
        servicesLocator.register(withBuilder: OpenWeatherClientServiceBuilder())
    }
    
    // MARK: Initialize first scene
    func initializeScene() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        createMainScene()
    }
    
    private func createMainScene() {
        guard let window = window else {
            return
        }
        window.rootViewController = createMainNavigationController()
    }

    private func createMainNavigationController() -> UINavigationController {
        let mainNavigationController = UINavigationController(rootViewController: createMainSceneViewController())
        mainNavigationController.navigationBar.tintColor = UIColor.white
        mainNavigationController.navigationBar.backgroundColor = UIColor.white
        return mainNavigationController
    }

    private func createMainSceneViewController() -> UIViewController {
        return UIViewController()
    }

}
