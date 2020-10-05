//
//  SceneBuilderProtocol.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

protocol SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController
}

extension SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol), viewModel: ViewModelProtocol, type: SceneTypes) -> UIViewController {
        guard let viewController = appCoordinator.getSceneViewController(forViewModel: viewModel, type: type) else {
            fatalError("can't get view controller")
        }
        return viewController
    }
}
