//
//  OpenWeatherClientService.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 01/10/2020.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

final class OpenWeatherClientServiceBuilder: ServiceBuilderProtocol {
    var type: ServiceTypes {
        return .openWeatherApi
    }
    
    func createService(withServiceLocator serviceLocator: ServiceLocator) -> Any {
        return OpenWeatherClientService()
    }
}

final class OpenWeatherClientService: OpenWeatherClient {
    
}

// MARK: AccuweatherClientServiceProtocol
extension OpenWeatherClientService: OpenWeatherClientServiceProtocol {
    func currentWeather(longitude: Float, latitude: Float) -> Observable<(HTTPURLResponse, WeatherModel?)> {
        return responseMapped(parameters: parametersForCurrentWeather(longitude: longitude, latitude: latitude))
    }
    
    func currentWeather(forCity name: String) -> Observable<(HTTPURLResponse, WeatherModel?)> {
        return responseMapped(parameters: parametersForCurrentWeather(cityName: name))
    }
    
}
