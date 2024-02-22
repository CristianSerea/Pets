//
//  MockURLSession.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import Foundation
import RxSwift
@testable import Pets

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func rxData(request: URLRequest) -> Observable<Data> {
        if let error = mockError {
            return Observable.error(error)
        }
        
        return Observable.of(mockData ?? Data())
    }
}
