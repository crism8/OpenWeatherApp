//
//  AppCoordinatorProtocol.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation

protocol AppCoordinatorProtocol: NSObjectProtocol {
    var isUserInteractionEnabled: Bool { get set }
    
    func initializeScene()
}

protocol AppCoordinatorResouresProtocol: NSObjectProtocol {
    func getService<ReturnType>(type: ServiceTypes) -> ReturnType?
    func getSceneViewController(forViewModel viewModel: ViewModelProtocol, type: SceneTypes) -> ViewControllerProtocol?
}
