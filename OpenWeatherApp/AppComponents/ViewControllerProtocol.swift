//
//  ViewControllerProtocol.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

public protocol ViewControllerProtocol: UIViewController {
    var viewModelInstance: Any { get }
    
    init(viewModel: ViewModelProtocol)
}
