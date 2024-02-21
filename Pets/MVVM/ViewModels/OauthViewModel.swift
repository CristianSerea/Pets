//
//  OauthViewModel.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation
import RxCocoa
import RxSwift

class OauthViewModel {
    var oauth: PublishSubject<Oauth> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    
    private let session: URLSessionProtocol
    private let disposeBag = DisposeBag()
    
    init(session: URLSessionProtocol? = nil) {
        self.session = session ?? URLSession(configuration: .default)
    }
    
    func fetchData() {
        guard let url = URL(string: GlobalConstants.Server.domain + GlobalConstants.Server.oauth) else {
            return
        }
        
        var request = URLRequest(url: url)
        
        if let error = format(request: &request) {
            return self.error.onNext(error)
        }
        
        session.fetchData(withRequest: request, type: Oauth.self)
            .subscribe(
                onNext: { [weak self] oauth in
                    self?.oauth.onNext(oauth)
                },
                onError: { [weak self] error in
                    self?.error.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func format(request: inout URLRequest) -> Error? {
        request.httpMethod = HTTPMethod.POST.rawValue
        request.addValue(ParameterConstants.applicationJSON, forHTTPHeaderField: ParameterConstants.contentType)
        
        let parameters = [
            ParameterConstants.grantType: ParameterConstants.clientCredentials,
            ParameterConstants.clientId: GlobalConstants.Credentials.clientId,
            ParameterConstants.clientSecret: GlobalConstants.Credentials.clientSecret]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            return nil
        } catch {
            return error
        }
    }
}
