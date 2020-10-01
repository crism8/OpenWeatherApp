//
//  BaseApiClient.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 30/09/2020.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class BaseApiClient: NSObject {

    private(set) var urlBuilder: URLBuilder!
    private(set) var session: Session!

    override init() {
        super.init()
        urlBuilder = URLBuilder(apiAddress: apiAddress, apiVersion: apiVersion)
        session = createSession()
    }
    
    var apiAddress: String {
        fatalError("Subclasses need to implement the `apiAddress` method.")
    }
    
    var apiVersion: String? {
        return "2.5"
    }
    
    func createSession() -> Session {
        return Session()
    }
    
    func createDefaultHeaders() -> HTTPHeaders? {
        return nil
    }
    
    func createDefaultParameters() -> [String: Any]? {
        return nil
    }
    
    func defaultEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }

    func defaultDataMapper() -> ApiDataMapperProtocol {
        return ApiDataToJsonMapper.default
    }
    
    func validate(response: HTTPURLResponse, data: Any?)throws {
        if !(200 ... 299 ~= response.statusCode) || data == nil {
            Logger.shared.logValidateFailure(response)
            try throwError(forResponse: response, data: data, originalError: ApiErrors.validation)
        } else {
            Logger.shared.logValidateSucccess(response)
        }
    }
    
    func validate<DataType>(responseData: Observable<(HTTPURLResponse, DataType)>, ifNeed needToValidate: Bool) -> Observable<(HTTPURLResponse, DataType)> {
        guard needToValidate else {
            return responseData
        }
        return responseData.do(onNext: { [weak self](response: HTTPURLResponse, data: DataType) in
            guard let self = self else {
                return
            }
            try self.validate(response: response, data: data)
        })
    }
    
    private func throwError(forResponse response: HTTPURLResponse, data: Any?, originalError: Error)throws {
        throw ApiErrorContainer(response: response, data: data, originalError: originalError)
    }
        
    func responseMapped<MapTo: Codable>(parameters: ApiRequestParameters, mapper: ApiDataMapperProtocol? = nil, validate validateResponse: Bool = true) -> Observable<(HTTPURLResponse, MapTo?)> {
        let dataResponse = self.requestData(parameters: parameters)
            .responseData()
            .map({ [weak self] (response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data, MapTo?) in
                guard let self = self else {
                    return (response, data, nil)
                }
                let mappedData: MapTo? = try self.map(response: response, data: data, mapper: mapper)
                return (response, data, mappedData)
            })
            .doOnce({ (response, error) in
                Logger.shared.log(response?.0, data: response?.1, mappedData: response?.2 as? LogDataRecudible, error: error)
            })
            .map({ (response: HTTPURLResponse, _: Data, mappedData: MapTo?) -> (HTTPURLResponse, MapTo?) in
                return (response, mappedData)
            })
        
        return validate(responseData: dataResponse, ifNeed: validateResponse)
    }
    
    func responseData(parameters: ApiRequestParameters, validate validateResponse: Bool = true) -> Observable<(HTTPURLResponse, Data)> {
        let dataResponse = self.requestData(parameters: parameters)
            .responseData()
            .doOnce({ (response, error) in
                Logger.shared.log(response?.0, data: response?.1, error: error)
            })
        return validate(responseData: dataResponse, ifNeed: validateResponse)
    }
    
    private func requestData(parameters: ApiRequestParameters) -> Observable<DataRequest> {
        let requestHeaders = createRequestHeaders(withHeaders: parameters.headers)
        let requestParameters = createRequestParameters(withParamters: parameters.parameters)
        let requestEncoding: ParameterEncoding = parameters.encoding ?? defaultEncoding(forMethod: parameters.method)

        return session.rx.request(parameters.method, parameters.url, parameters: requestParameters, encoding: requestEncoding, headers: requestHeaders).do(onNext: { (dataRequest) in
            Logger.shared.log(dataRequest)
        })
    }
    
    private func createRequestHeaders(withHeaders headers: [String: String]?) -> HTTPHeaders {
        var requestHeaders = createDefaultHeaders() ?? [:]
        guard let headers = headers else {
            return requestHeaders
        }
        for header in headers {
            requestHeaders[header.key] = header.value
        }
        return requestHeaders
    }
    
    private func createRequestParameters(withParamters parameters: [String: Any]?) -> [String: Any] {
        var requestParameters = createDefaultParameters() ?? [:]
        guard let parameters = parameters else {
            return requestParameters
        }
        for parameter in parameters {
            requestParameters[parameter.key] = parameter.value
        }
        return requestParameters
    }
    
    private func map<MapTo: Codable>(response: HTTPURLResponse, data: Data, mapper: ApiDataMapperProtocol?) throws -> MapTo? {
        var mappedData: MapTo?
        do {
            mappedData = try (mapper ?? self.defaultDataMapper()).mapTo(data: data)
        } catch {
            try self.throwError(forResponse: response, data: data, originalError: error)
        }
        return mappedData
    }
}
