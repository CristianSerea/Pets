//
//  FilterTests.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest
@testable import Pets

class FilterTests: XCTestCase {
    func testCanBeDisabled() {
        let filter1 = Filter(filterType: .PetType)
        XCTAssertFalse(filter1.canBeDisabled)
        
        let filter2 = Filter(filterType: .Gender)
        XCTAssertFalse(filter2.canBeDisabled)
        
        let filter3 = Filter(filterType: .Location)
        XCTAssertFalse(filter3.canBeDisabled)
        
        let filter4 = Filter(filterType: .Distance)
        XCTAssertTrue(filter4.canBeDisabled)
    }
    
    func testHint() {
        var filter = Filter(filterType: .Distance)
        XCTAssert(filter.hint == "Tap to change")
        
        filter.isEnabled = false
        XCTAssert(filter.hint == "Available after selecting a location")
    }
}
