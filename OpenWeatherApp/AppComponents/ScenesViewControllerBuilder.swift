//
//  ScenesViewControllerBuilder.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

public enum SceneTypes {
    case currentWeather
}

public final class ScenesViewControllerBuilder {
    private var viewControllerForTypes: [SceneTypes: UIViewController.Type] = [:]
    
    public func register(viewControllerType: UIViewController.Type, forType type: SceneTypes) {
        viewControllerForTypes[type] = viewControllerType
    }
    
    func get(forViewModel viewModel: ViewModelProtocol, type: SceneTypes) -> ViewControllerProtocol? {
        guard let viewControllerType = viewControllerForTypes[type] as? ViewControllerProtocol.Type else {
            return nil
        }
        return viewControllerType.init(viewModel: viewModel)
    }
}
