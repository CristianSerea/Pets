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
    private let oauthManager: OauthManager?
    private let disposeBag = DisposeBag()
    
    var petsWrapperValue: PetsWrapper? {
        return try? petsWrapper.value()
    }
    
    init(session: URLSessionProtocol? = nil,
         withOauthManager oauthManager: OauthManager?) {
        self.session = session ?? URLSession(configuration: .default)
        self.oauthManager = oauthManager
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
        
        let request = URLRequest(url: url)
        
        session.fetchData(withRequest: request, type: PetsWrapper.self, withOauthManager: oauthManager)
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
}
