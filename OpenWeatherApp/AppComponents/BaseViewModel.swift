//
//  BaseViewModel.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

public enum DataActionStates {
    case none
    case loading
    case loadingMore
    case error
    case empty
}

class BaseViewModel: BaseDataController, ViewModelProtocol {
    
    private(set) weak var appCoordinator: AppCoordinatorProtocol?
    
    init(appCoordinator: AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }
    
    func forward(dataControllerState dataController: BaseDataController) {
        dataController.dataActionStateDriver.drive(onNext: { [weak self] dataActionState in
            self?.dataActionState = dataActionState
        }).disposed(by: dataController.disposeBag)
        
        dataController.raiseErrorDriver.drive(onNext: { [weak self] error in
            self?.raise(error: error)
        }).disposed(by: dataController.disposeBag)
    }
}
