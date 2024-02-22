//
//  OauthManager.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation
import RxSwift

protocol OauthManagerDelegate {
    func oauthDidFetch(error: Error?)
}

class OauthManager {
    var oauthManagerDelegate: OauthManagerDelegate?
    
    private var oauthViewModel: OauthViewModel?
    private let disposeBag = DisposeBag()
    
    var oauth: Oauth? {
        didSet {
            oauthManagerDelegate?.oauthDidFetch(error: nil)
        }
    }
    
    func loadOauth() {
        retrieveOauth()
    }

    func fetchData(completion: (() -> Void)? = nil) {
        if oauthViewModel == nil {
            oauthViewModel = OauthViewModel()
            oauthViewModel?.oauth.asObserver()
                .bind { [weak self] oauth in
                    self?.saveOauth(withOauth: oauth)
                }
                .disposed(by: disposeBag)
            
            oauthViewModel?.error.asObserver()
                .bind { [weak self] error in
                    self?.oauthManagerDelegate?.oauthDidFetch(error: error)
                }
                .disposed(by: disposeBag)
        }
        
        oauthViewModel?.fetchData(completion: completion)
    }
}

extension OauthManager {
    private func retrieveOauth() {
        switch KeychainHelper.retrieveItem(withKey: ParameterConstants.oauth) {
        case .success(let data):
            if let data = data {
                do {
                    let oauthWrapper = try JSONDecoder().decode(OauthWrapper.self, from: data)
                    validateOauth(withOauthWrapper: oauthWrapper)
                } catch {
                    oauthManagerDelegate?.oauthDidFetch(error: error)
                }
            } else {
                fetchData()
            }
        case .failure(let error):
            oauthManagerDelegate?.oauthDidFetch(error: error)
        }
    }
    
    private func saveOauth(withOauth oauth: Oauth) {
        let oauthWrapper = OauthWrapper(oauth: oauth, date: Date())
        
        do {
            let data = try JSONEncoder().encode(oauthWrapper)
            if let error = KeychainHelper.saveItem(withKey: ParameterConstants.oauth, withData: data) {
                oauthManagerDelegate?.oauthDidFetch(error: error)
            } else {
                self.oauth = oauth
            }
        } catch {
            oauthManagerDelegate?.oauthDidFetch(error: error)
        }
    }
    
    private func validateOauth(withOauthWrapper oauthWrapper: OauthWrapper) {
        if Int(Date().timeIntervalSince(oauthWrapper.date)) < oauthWrapper.oauth.expires_in {
            self.oauth = oauthWrapper.oauth
        } else {
            fetchData()
        }
    }
}
