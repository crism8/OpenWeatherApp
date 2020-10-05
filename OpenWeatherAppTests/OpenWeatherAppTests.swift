//
//  OpenWeatherAppTests.swift
//  OpenWeatherAppTests
//
//  Created by Cristian Makarski on 28/09/2020.
//

import XCTest
import RxSwift
@testable import OpenWeatherApp

class OpenWeatherAppTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func testCurrentWeather() throws {
        let exp = expectation(description: "Request expectation")
        var reqError: Error?
        var currentWeatherResults: WeatherModel?
        
        let openWeatherClientService = OpenWeatherClientService()
        openWeatherClientService.currentWeather(forCity: "warsaw")
            .subscribe({ event in
                guard !event.isCompleted else {
                    return
                }
                guard event.error == nil else {
                    reqError = event.error
                    return
                }
                currentWeatherResults = event.element?.1
                exp.fulfill()
                
            }).disposed(by: disposeBag)
        waitForExpectations(timeout: 2.5)
        XCTAssertNil(reqError)
        XCTAssertNotNil(currentWeatherResults)
        XCTAssertEqual(currentWeatherResults?.name, "Warsaw")
        XCTAssertEqual(currentWeatherResults?.coordinates.latitude, 52.23)
        XCTAssertEqual(currentWeatherResults?.coordinates.longitude, 21.01)
        XCTAssertEqual(currentWeatherResults?.name, "Warsaw")
        XCTAssertEqual(currentWeatherResults?.name, "Warsaw")
        guard let currentWeather = currentWeatherResults else {
            return
        }
        XCTAssertTrue(currentWeather.main.tempereture < 30)
        XCTAssertTrue(currentWeather.main.minTemperature < 30)
        XCTAssertTrue(currentWeather.main.maxTemperature < 30)

    }

}
