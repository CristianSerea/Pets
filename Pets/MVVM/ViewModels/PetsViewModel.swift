//
//  PetsViewModel.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation
import RxCocoa
import RxSwift

class PetsViewModel {
    var petsWrapper: BehaviorSubject<PetsWrapper?> = BehaviorSubject(value: nil)
    var error: PublishSubject<Error> = PublishSubject()
    
    private let session: URLSessionProtocol
    private let oauth: Oauth
    private let disposeBag = DisposeBag()
    
    var petsWrapperValue: PetsWrapper? {
        return try? petsWrapper.value()
    }
    
    init(session: URLSessionProtocol? = nil,
         withOauth oauth: Oauth) {
        self.session = session ?? URLSession(configuration: .default)
        self.oauth = oauth
    }
    
    func fetchData(withHref href: String? = nil,
                   withQuery query: String? = nil) {
        var string: String {
            guard let query = query else {
                return GlobalConstants.Server.pets
            }
            
            return GlobalConstants.Server.pets + "?" + query
        }
        
        let path = href ?? string
        
        guard let url = URL(string: GlobalConstants.Server.domain + path) else {
            return
        }
        
        var request = URLRequest(url: url)
        format(request: &request)
        
        session.fetchData(withRequest: request, type: PetsWrapper.self)
            .subscribe(
                onNext: { [weak self] petsWrapper in
                    if let petsWrapperValue = self?.petsWrapperValue {
                        var animals: [Pet] {
                            guard href != nil else {
                                return petsWrapper.animals
                            }
                            
                            return petsWrapperValue.animals + petsWrapper.animals
                        }
                        
                        let petsWrapper = PetsWrapper(animals: animals,
                                                      pagination: petsWrapper.pagination)
                        self?.petsWrapper.onNext(petsWrapper)
                    } else {
                        self?.petsWrapper.onNext(petsWrapper)
                    }
                },
                onError: { [weak self] error in
                    self?.error.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func format(request: inout URLRequest) {
        let parameters = [ParameterConstants.authorization: oauth.token_type + " " + oauth.access_token]
        request.allHTTPHeaderFields = parameters
    }
}
