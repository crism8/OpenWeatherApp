//
//  ApiRequestParameters.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 30/09/2020.
//

import Foundation
import Alamofire

struct ApiRequestParameters {
    let url: URL
    let method: HTTPMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
    let encoding: ParameterEncoding?
    
    init(url: URL, method: HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, encoding: ParameterEncoding? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
    }
}
