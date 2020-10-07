//
//  AppErrors+Creating.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation

extension AppError {
    public enum Codes: Int {
        case commonSelfNotExists = 100
        case commonDriverDefault = 101
        
        case apiConnection = 201
        case apiValidation = 202
        case apiMapping = 203
        
        case location = 301

    }
    
    public enum UserInfoKeys: String {
        case apiResponse // HTTPURLResponse
        case apiData // Data
        case location // Location

    }
    
    static func createDescriptionKeysForErrorCodes() -> [AppError.Codes: String] {
        return [.apiConnection: "error_connection",
                .apiValidation: "error_validation",
                .apiMapping: "error_parse",
                .location: "error_location"
                ]
    }
    
    static func apiError(withCode code: AppError.Codes, forResponse response: HTTPURLResponse, data: Any?, originalError: Error?) -> AppError {
        var userInfo: [String: Any] = [AppError.UserInfoKeys.apiResponse.rawValue: response]
        if let data = data {
            userInfo[AppError.UserInfoKeys.apiData.rawValue] = data
        }
        return AppError(withCode: code, userInfo: userInfo, innerError: originalError as NSError?)
    }
    
    static func locationError(withCode code: AppError.Codes, message: String) -> AppError {
        let userInfo: [String: Any] = [AppError.UserInfoKeys.location.rawValue: message]
        return AppError(withCode: code, userInfo: userInfo, innerError: nil as NSError?)
    }
}
