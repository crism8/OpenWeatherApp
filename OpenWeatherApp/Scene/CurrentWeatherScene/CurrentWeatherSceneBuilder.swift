//
//  CurrentWeatherSceneBuilder.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

struct CurrentWeatherSceneBuilder: SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        guard let openWeatherClient: OpenWeatherClientServiceProtocol = appCoordinator.getService(type: .openWeatherApi) else {
            fatalError("CurrentWeatherSceneBuilder can't get openWeatherClient service")
        }
        let currentWeatherUseCase = CurrentWeatherUseCase(openWeatherClient: openWeatherClient)
        let viewModel = CurrentWeatherViewModel(appCoordinator: appCoordinator, currentWeatherUseCase: currentWeatherUseCase)
        return createScene(withAppCoordinator: appCoordinator, viewModel: viewModel, type: .currentWeather)
    }
}
