//
//  ViewModelProtocol.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import RxSwift
import RxCocoa

public protocol ViewModelProtocol {
    var dataActionState: DataActionStates { get }
    var dataActionStateDriver: Driver<DataActionStates> { get }
    var raiseErrorDriver: Driver<Error> { get }
    
    func raise(error: Error)
}
