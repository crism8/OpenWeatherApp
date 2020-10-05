//
//  ApiErrors.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 30/09/2020.
//

import Foundation

enum ApiErrors: String, LocalizedError {
    case connection = "error_connection"
    case validation = "error_validation"

    var errorDescription: String {
        return self.rawValue.localized
    }
}
