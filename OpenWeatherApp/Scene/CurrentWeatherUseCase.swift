//
//  CurrentWeatherUseCase.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

final class CurrentWeatherUseCase: BaseDataController {
    
    private var openWeatherClient: OpenWeatherClientServiceProtocol
    private var dataActionStateRelay: BehaviorRelay<DataActionStates> = BehaviorRelay<DataActionStates>(value: .none)
    private var raiseErrorSubject: PublishSubject<Error> = PublishSubject<Error>()
    private var currentWeatherRelay: BehaviorRelay<WeatherModel> = BehaviorRelay<WeatherModel>(value: WeatherModel.empty)
    private var locationManager: CLLocationManager!
    
    var currentWeather: WeatherModel {
        return currentWeatherRelay.value
    }
    
    var currentWeatherDriver: Driver<WeatherModel> {
        return currentWeatherRelay.asDriver()
    }
    
    // MARK: INIT
    init(openWeatherClient: OpenWeatherClientServiceProtocol) {
        self.openWeatherClient = openWeatherClient
        self.locationManager = CLLocationManager()
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
        self.locationManager.stopUpdatingLocation()
        self.dataActionState = .none
        self.currentWeatherRelay.accept(WeatherModel.empty)
    }
    
    func locationWeather() {
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
            .flatMap { [weak self] coordinates -> Observable<(HTTPURLResponse, WeatherModel?)> in
                guard let self = self else {
                    throw AppError.locationError(withCode: .location, message: "Location Error")
                }
                return self.openWeatherClient.currentWeather(longitude: Float(coordinates.longitude), latitude: Float(coordinates.latitude))
            }
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
    
    private func requestLocation() -> Observable<CLLocationCoordinate2D> {
        let locationStream: Observable<CLLocationCoordinate2D> = self.locationManager.rx
            .didUpdateLocations
            .filter {
                $1.count > 0
            }
            .map {
                $1.last!.coordinate
            }
        
        let errorStream: Observable<CLLocationCoordinate2D> = self.locationManager
            .rx
            .didError
            .flatMap { return Observable.error($0.error) }
        
        return Observable.merge(locationStream, errorStream)
            .do(onSubscribe: { [unowned self] in self.locationManager.startUpdatingLocation() },
                onDispose: { [unowned self] in self.locationManager.stopUpdatingLocation() })
    }
    
}
