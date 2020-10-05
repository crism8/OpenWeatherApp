//
//  OpenWeatherClient.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 01/10/2020.
//

import Foundation

import Alamofire
import RxSwift
import RxAlamofire

enum OpenWeatherURLComponents: String {
    case weather
}

enum OpenWeatherMethodNamespace: String {
    case data
}

class OpenWeatherClient: BaseApiClient {
    override var apiAddress: String {
        return AppSettings.Api.openWeatherAddress
    }

    override func createDefaultHeaders() -> HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }

    override func createDefaultParameters() -> [String: Any]? {
        return ["appid": AppSettings.Api.key]
    }
    
    func parametersForCurrentWeather(cityName: String, units: String? = "metric") -> ApiRequestParameters {
        let urlComponents = [
            OpenWeatherURLComponents.weather.rawValue
        ]
        let parameters: [String: Any] = [
            "q": cityName,
            "units": units ?? "metric"
        ]
        return ApiRequestParameters(url: urlBuilder.build(components: urlComponents, namespace: OpenWeatherMethodNamespace.data.rawValue)!, method: .get, parameters: parameters)
    }
    
    func parametersForCurrentWeather(longitude: Float, latitude: Float, units: String? = "metric") -> ApiRequestParameters {
        let urlComponents = [
            OpenWeatherURLComponents.weather.rawValue
        ]
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "units": units ?? "metric"
        ]
        return ApiRequestParameters(url: urlBuilder.build(components: urlComponents, namespace: OpenWeatherMethodNamespace.data.rawValue)!, method: .get, parameters: parameters)
    }

}
