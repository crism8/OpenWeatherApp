//
//  AppSettings.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 29/09/2020.
//

import Foundation

struct AppSettings {
    struct Api {

        // MARK: API KEY
        static var key: String {
            return "4afb83b47f46aef2860f71631ce1e24e"
        }

        static var openWeatherAddress: String {
            return "http://api.openweathermap.org"
        }
    }
}
