//
//  BaseDataController.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

class BaseDataController {
    private var dataActionStateRelay: BehaviorRelay<DataActionStates> = BehaviorRelay<DataActionStates>(value: .none)
    private var raiseErrorSubject: PublishSubject<Error> = PublishSubject<Error>()
    let disposeBag = DisposeBag()
    
    var dataActionState: DataActionStates {
        get {
            return dataActionStateRelay.value
        }
        set {
            dataActionStateRelay.accept(newValue)
        }
    }
    
    var dataActionStateDriver: Driver<DataActionStates> {
        return dataActionStateRelay.asDriver()
    }
    
    var raiseErrorDriver: Driver<Error> {
        return raiseErrorSubject.asDriver(onErrorJustReturn: AppError(withCode: .commonDriverDefault))
    }
    
    func raise(error: Error) {
        raiseErrorSubject.onNext(error)
    }
}
