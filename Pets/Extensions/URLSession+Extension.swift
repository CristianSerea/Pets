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
    func fetchData<T: Decodable>(withRequest request: URLRequest, type: T.Type) -> Observable<T> {
        return rxData(request: request)
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
                        if failure.isUnauthorized {
                            return refreshToken(withRequest: request, type: type)
                        } else {
                            return Observable.error(failure)
                        }
                        
                    } catch {
                        throw error
                    }
                }
                
                return Observable.error(error)
            }
            .observe(on: MainScheduler.instance)
    }
    
    func refreshToken<T: Decodable>(withRequest request: URLRequest, type: T.Type) -> Observable<T> {
        return fetchData(withRequest: request, type: type)
    }
}

extension URLSession: URLSessionProtocol {
    func rxData(request: URLRequest) -> Observable<Data> {
        return rx.data(request: request)
    }
}
