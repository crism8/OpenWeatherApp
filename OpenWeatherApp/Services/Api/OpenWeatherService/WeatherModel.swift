//
//  WeatherModel.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 01/10/2020.
//

import Foundation

public struct WeatherModel: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case main = "main"
        case base = "base"
        case weather = "weather"
        case coordinates = "coord"
    }
    let name: String
    let main: WeatherMainModel
    let base: String
    let weather: [WeatherDescriptionModel]
    let coordinates: CoordinatesModel

    static var empty: WeatherModel {
        WeatherModel(name: "", main: WeatherMainModel.empty, base: "", weather: [], coordinates: CoordinatesModel.empty)
    }

}

public struct CoordinatesModel: Codable {
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    let longitude: Float
    let latitude: Float
    
    static var empty: CoordinatesModel {
        CoordinatesModel(longitude: 0, latitude: 0)
    }
}

public struct WeatherDescriptionModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    static var empty: WeatherDescriptionModel {
        WeatherDescriptionModel(id: 0, main: "", description: "", icon: "")
    }

}

public struct WeatherMainModel: Codable {
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    let temperature: Float
    let feelsLike: Float
    let minTemperature: Float
    let maxTemperature: Float
    let pressure: Float
    let humidity: Float
    
    static var empty: WeatherMainModel {
        WeatherMainModel(temperature: 0, feelsLike: 0, minTemperature: 0, maxTemperature: 0, pressure: 0, humidity: 0)
    }
}
