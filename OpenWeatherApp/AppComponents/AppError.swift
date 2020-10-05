//
//  AppError.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation

public final class AppError: NSError, LocalizedError {
    private static var descriptionKeysForErrorCodes = {
        createDescriptionKeysForErrorCodes()
    }()
    
    private var pDescription: String
    public let innerError: NSError?
    public static let errorDomain = "pl.crism.OpenWeatherApp"
    
    public var errorDescription: String? {
        return pDescription
    }
    
    public init(withCode code: AppError.Codes, userInfo: [String: Any]? = nil, innerError: NSError? = nil) {
        pDescription = Self.descriptionKeysForErrorCodes[code]?.localized ?? "error_general".localized
        if let innerError = innerError {
            let lastDomainPath = innerError.domain.split(separator: ".").last ?? ""
            pDescription += "\n(\(lastDomainPath) \(innerError.code))"
        } else {
            pDescription += "\n(app \(code.rawValue))"
        }
        
        var userInfoMutable: [String: Any] = userInfo ?? [:]
        userInfoMutable[NSLocalizedDescriptionKey] = pDescription
        
        self.innerError = innerError
        super.init(domain: Self.errorDomain, code: code.rawValue, userInfo: userInfoMutable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
