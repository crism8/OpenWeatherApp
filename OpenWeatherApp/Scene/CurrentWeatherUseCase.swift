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
    
    private func requestStatusObservable() -> Observable<CLAuthorizationStatus> {
        let statusObservable: Observable<CLAuthorizationStatus> = locationManager!
            .rx
            .status
            .filter {
                $0 == .notDetermined
            }
        
        let didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> = locationManager!
            .rx
            .didChangeAuthorization
            .map { $0.status }
        return Observable.merge(statusObservable, didChangeAuthorizationStatus)
    }

//    private func requestStatus() {
//        requestStatusObservable()
//            .subscribe({ [weak self] status in
//                guard let self = self else {
//                    return
//                }
//
//                switch status.element {
//                case .denied:
//                    print("Authorization denied")
//                    throw AppError.locationError(withCode: .location, message: "Location Authorization denied")
//                case .notDetermined:
//                    print("Authorization: not determined")
//                    throw AppError.locationError(withCode: .location, message: "Location Authorization: not determined")
//                case .restricted:
//                    print("Authorization: restricted")
//                    throw AppError.locationError(withCode: .location, message: "Location Authorization: restricted")
//                case .authorizedAlways, .authorizedWhenInUse:
//                    print("All good fire request)")
//                @unknown default:
//                    throw AppError.locationError(withCode: .location, message: "Not Handled location status")
//                }
//            }).disposed(by: disposeBag)
//    }

    
//    private func handle(status: CLAuthorizationStatus) throws {
//        switch status {
//        case .denied:
//            print("Authorization denied")
//            throw AppError.locationError(withCode: .location, message: "Location Authorization denied")
//        case .notDetermined:
//            print("Authorization: not determined")
//            throw AppError.locationError(withCode: .location, message: "Location Authorization: not determined")
//        case .restricted:
//            print("Authorization: restricted")
//            throw AppError.locationError(withCode: .location, message: "Location Authorization: restricted")
//        case .authorizedAlways, .authorizedWhenInUse:
//            print("All good fire request)")
//        @unknown default:
//            throw AppError.locationError(withCode: .location, message: "Not Handled location status")
//        }
//    }
    
}
