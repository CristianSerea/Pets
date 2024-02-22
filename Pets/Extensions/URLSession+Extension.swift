//
//  URLSession+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation
import RxCocoa
import RxSwift

protocol URLSessionProtocol {
    func rxData(request: URLRequest) -> Observable<Data>
}

extension URLSessionProtocol {
    func fetchData<T: Decodable>(withRequest request: URLRequest, type: T.Type,
                                 withOauthManager oauthManager: OauthManager? = nil) -> Observable<T> {
        let formattedRequest = getFormattedRequest(withRequest: request,
                                                   withOauthManager: oauthManager)
        
        return rxData(request: formattedRequest)
            .map { data -> T in
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    return object
                } catch {
                    throw error
                }
            }
            .catch { error -> Observable<T> in
                if let rxError = error as? RxCocoaURLError,
                   case let .httpRequestFailed(_, data) = rxError,
                   let data = data {
                    do {
                        let failure = try JSONDecoder().decode(Failure.self, from: data)
                        let observableError: Observable<T> = Observable.error(failure)
                        
                        guard failure.isUnauthorized else {
                            return observableError
                        }
                        
                        return refreshToken(withRequest: request, type: type, withOauthManager: oauthManager) ?? observableError
                    } catch {
                        throw error
                    }
                }
                
                return Observable.error(error)
            }
            .observe(on: MainScheduler.instance)
    }
    
    private func refreshToken<T: Decodable>(withRequest request: URLRequest, type: T.Type,
                                            withOauthManager oauthManager: OauthManager?) -> Observable<T>? {
        guard let oauthManager = oauthManager else {
            return nil
        }
        
        return Observable.create { observer in
            var fetchDataDisposable: Disposable?
            
            oauthManager.fetchData {
                fetchDataDisposable = fetchData(withRequest: request, type: type, withOauthManager: oauthManager)
                    .subscribe(observer)
            }
            
            return Disposables.create {
                fetchDataDisposable?.dispose()
            }
        }
    }
    
    private func getFormattedRequest(withRequest request: URLRequest,
                                     withOauthManager oauthManager: OauthManager? = nil) -> URLRequest {
        guard let oauth = oauthManager?.oauth else {
            return request
        }
        
        var formattedRequest = request
        let parameters = [ParameterConstants.authorization: oauth.token_type + " " + oauth.access_token]
        formattedRequest.allHTTPHeaderFields = parameters
        
        return formattedRequest
    }
}

extension URLSession: URLSessionProtocol {
    func rxData(request: URLRequest) -> Observable<Data> {
        return rx.data(request: request)
    }
}
