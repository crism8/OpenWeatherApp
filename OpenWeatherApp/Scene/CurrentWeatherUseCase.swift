//
//  CurrentWeatherUseCase.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoreLocation

final class CurrentWeatherUseCase: BaseDataController {
    
    private var openWeatherClient: OpenWeatherClientServiceProtocol
    private var dataActionStateRelay: BehaviorRelay<DataActionStates> = BehaviorRelay<DataActionStates>(value: .none)
    private var raiseErrorSubject: PublishSubject<Error> = PublishSubject<Error>()
    private var currentWeatherRelay: BehaviorRelay<WeatherModel> = BehaviorRelay<WeatherModel>(value: WeatherModel.empty)

    var currentWeather: WeatherModel {
        return currentWeatherRelay.value
    }
    
    var currentWeatherDriver: Driver<WeatherModel> {
        return currentWeatherRelay.asDriver()
    }
    
    // MARK: INIT
    init(openWeatherClient: OpenWeatherClientServiceProtocol) {
        self.openWeatherClient = openWeatherClient
        super.init()
    }
    
    func currentWeather(forPlace place: String) {
        clear()
        guard place.count > 0 else {
            return
        }
        openWeatherClient.currentWeather(forCity: place)
            .subscribe({ [weak self] currentWeather in
                guard let self = self else {
                    return
                }
                if let error = currentWeather.error {
                    self.dataActionState = .error
                    self.raise(error: error)
                    return
                }
                if let weather = currentWeather.element?.1 {
                    self.currentWeatherRelay.accept(weather)
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func clear() {
        self.dataActionState = .none
        self.currentWeatherRelay.accept(WeatherModel.empty)
    }
    
}
