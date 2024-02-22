//
//  OauthViewModelTests.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest
import RxSwift
import RxCocoa
@testable import Pets

class OauthViewModelTests: XCTestCase {
    private var mockSession: MockURLSession?
    private var oauthViewModel: OauthViewModel?
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        
        mockSession = MockURLSession()
        oauthViewModel = OauthViewModel(session: mockSession)
    }

    func testFetchDataSuccess() {
        mockSession?.mockData = MockConstants.SessionMock.oauthData
        
        let expectation = XCTestExpectation(description: "Oauth fetched with success")
        
        oauthViewModel?.oauth.asObservable()
            .subscribe(onNext: { oauth in
                XCTAssertFalse(oauth.token_type.isEmpty)
                XCTAssertGreaterThan(oauth.expires_in, .zero)
                XCTAssertFalse(oauth.access_token.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        oauthViewModel?.fetchData()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchDataFailure() {
        mockSession?.mockError = NSError(domain: "mockError", code: 1000, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Oauth fetched with error")
        
        oauthViewModel?.error.asObservable()
            .subscribe(onNext: { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        oauthViewModel?.fetchData()
        
        wait(for: [expectation], timeout: 2.0)
    }
}
