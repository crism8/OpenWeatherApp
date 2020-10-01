//
//  WeatherModel.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 01/10/2020.
//

import Foundation

struct WeatherModel: Codable {
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

}

struct CoordinatesModel: Codable {
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    let longitude: Float
    let latitude: Float
}

struct WeatherDescriptionModel: Codable {
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

}

struct WeatherMainModel: Codable {
    enum CodingKeys: String, CodingKey {
        case tempereture = "temp"
        case feelsLike = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    let tempereture: Float
    let feelsLike: Float
    let minTemperature: Float
    let maxTemperature: Float
    let pressure: Float
    let humidity: Float
}

//{latitude and longitude with interactive Maps
//  "base": "stations",
//  "main": {
//    "temp": 282.55,
//    "feels_like": 281.86,
//    "temp_min": 280.37,
//    "temp_max": 284.26,
//    "pressure": 1023,
//    "humidity": 100
//  },
//  "visibility": 16093,
//  "wind": {
//    "speed": 1.5,
//    "deg": 350
//  },
//  "clouds": {
//    "all": 1
//  },
//  "dt": 1560350645,
//  "sys": {
//    "type": 1,
//    "id": 5122,
//    "message": 0.0139,
//    "country": "US",
//    "sunrise": 1560343627,
//    "sunset": 1560396563
//  },
//  "timezone": -25200,
//  "id": 420006353,
//  "name": "Mountain View",
//  "cod": 200
//  }
