//
//  URLBuilder.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 30/09/2020.
//

import Foundation

final class URLBuilder {
    private let defaultApiAddress: String
    private let defaultApiVersion: String?
    
    init(apiAddress: String, apiVersion: String?) {
        self.defaultApiAddress = apiAddress
        self.defaultApiVersion = apiVersion
    }
    
    func build(components: [String], namespace: String, apiAddress: String? = nil, apiVersion: String? = nil) -> URL? {
        guard var url = URL(string: apiAddress ?? defaultApiAddress) else {
            return nil
        }
        
        url.appendPathComponent(namespace)
        
        if let version = apiVersion ?? defaultApiVersion {
            url.appendPathComponent(version)
        }
        
        for component in components {
            url.appendPathComponent(component)
        }
        
        return url
    }
}
