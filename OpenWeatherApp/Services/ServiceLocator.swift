//
//  ServiceLocator.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 29/09/2020.
//

import Foundation

protocol ServiceBuilderProtocol {
    var type: ServiceTypes { get }

    func createService(withServiceLocator serviceLocator: ServiceLocator) -> Any
}

enum ServiceTypes {
    case openWeatherApi
    case dataStore
}

final class ServiceLocator {
    private var builderForServices: [ServiceTypes: Any] = [:]
    private var serviceForTypes: [ServiceTypes: Any?] = [:]

    func register(withBuilder builder: ServiceBuilderProtocol) {
        builderForServices[builder.type] = builder
        serviceForTypes[builder.type] = nil
    }

    func get<ReturnType>(type: ServiceTypes) -> ReturnType? {
        guard serviceForTypes[type] == nil else {
            return serviceForTypes[type] as? ReturnType
        }

        return tryToCreateService(withType: type) as? ReturnType
    }

    private func tryToCreateService(withType type: ServiceTypes) -> Any? {
        guard let builder = builderForServices[type] as? ServiceBuilderProtocol else {
            return nil
        }
        let newService = builder.createService(withServiceLocator: self)
        serviceForTypes[type] = newService
        builderForServices[type] = nil
        return newService
    }
}
