//
//  PetsViewModelTests.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest
import RxSwift
import RxCocoa
@testable import Pets

class PetsViewModelTests: XCTestCase {
    private var mockSession: MockURLSession?
    private var petsViewModel: PetsViewModel?
    private var oauthManager: OauthManager?
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        
        mockSession = MockURLSession()
        oauthManager = OauthManager()
        oauthManager?.oauth = MockConstants.SessionMock.oauth
        
        petsViewModel = PetsViewModel(session: mockSession,
                                      withOauthManager: oauthManager)
    }

    func testFetchDataSuccess() {
        mockSession?.mockData = MockConstants.PetsMock.petsData
        
        let expectation = XCTestExpectation(description: "Pets fetched with success")
        
        petsViewModel?.petsWrapper.asObservable()
            .skip(1)
            .subscribe(onNext: { petsWrapper in
                XCTAssertNotNil(petsWrapper)
                if let petsWrapper = petsWrapper {
                    XCTAssertGreaterThanOrEqual(petsWrapper.animals.count, .zero)
                    XCTAssertGreaterThanOrEqual(petsWrapper.pagination.total_pages, .zero)
                }
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        petsViewModel?.fetchData()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchDataFailure() {
        mockSession?.mockError = NSError(domain: "mockError", code: 1000, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Pets fetched with error")
        
        petsViewModel?.error.asObservable()
            .subscribe(onNext: { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        petsViewModel?.fetchData()
        
        wait(for: [expectation], timeout: 2.0)
    }
}
