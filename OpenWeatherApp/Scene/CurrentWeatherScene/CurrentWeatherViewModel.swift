//
//  CurrentWeatherViewModel.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import RxSwift
import RxCocoa

public protocol CurrentWeatherViewModelProtocol: ViewModelProtocol {
    var isApiKeyValid: Bool { get }
    var currentWeatherDriver: Driver<WeatherModel> { get }
    var currentWeather: WeatherModel { get }

    func weather(forPlace place: String)
}

final class CurrentWeatherViewModel: BaseViewModel {
    private let currentWeatherUseCase: CurrentWeatherUseCase
    
    init(appCoordinator: AppCoordinatorProtocol, currentWeatherUseCase: CurrentWeatherUseCase) {
        self.currentWeatherUseCase = currentWeatherUseCase
        super.init(appCoordinator: appCoordinator)
        forward(dataControllerState: currentWeatherUseCase)
    }
}

// MARK: CurrentWeatherViewModelProtocol
extension CurrentWeatherViewModel: CurrentWeatherViewModelProtocol {
    
    var isApiKeyValid: Bool {
        return !AppSettings.Api.key.isEmpty
    }
    
    var currentWeatherDriver: Driver<WeatherModel> {
        return currentWeatherUseCase.currentWeatherDriver
    }
    
    var currentWeather: WeatherModel {
        currentWeatherUseCase.currentWeather
    }
    
    func weather(forPlace place: String) {
        currentWeatherUseCase.currentWeather(forPlace: place)
    }
    
}
