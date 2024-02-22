//
//  FailureTests.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest
@testable import Pets

class FailureTests: XCTestCase {
    func testErrorDescription() {
        let failure = Failure(type: "type", status: 404, title: "Not Found", detail: "Resource not found")
        XCTAssertEqual(failure.errorDescription, "404 Not Found\nResource not found.")
    }
    
    func testIsUnauthorized() {
        let unauthorizedFailure = Failure(type: "type", status: 401, title: "Unauthorized", detail: "Invalid token")
        XCTAssertTrue(unauthorizedFailure.isUnauthorized)
        
        let forbiddenFailure = Failure(type: "type", status: 403, title: "Forbidden", detail: "Invalid token")
        XCTAssertTrue(forbiddenFailure.isUnauthorized)
    }
}
