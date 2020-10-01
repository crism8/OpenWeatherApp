//
//  OpenWeatherClientServiceProtocol.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 01/10/2020.
//

import Foundation
import RxSwift

protocol OpenWeatherClientServiceProtocol: NSObjectProtocol {
    func currentWeather(forCity name: String) -> Observable<(HTTPURLResponse, WeatherModel?)>

}
