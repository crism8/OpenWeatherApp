//
//  ApiErrorContainer.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 30/09/2020.
//

import Foundation

struct ApiErrorContainer: LocalizedError {
    let response: HTTPURLResponse
    let data: Any?
    let originalError: Error

    var errorDescription: String {
        return originalError.localizedDescription
    }

    init(response: HTTPURLResponse, data: Any?, originalError: Error) {
        self.response = response
        self.data = data
        self.originalError = originalError
    }
}
