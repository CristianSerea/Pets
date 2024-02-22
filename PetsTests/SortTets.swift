//
//  SortTets.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest
@testable import Pets

class SortTets: XCTestCase {
    func testCanBeDisabled() {
        let sort1 = Sort(sortType: .DateShuffled)
        XCTAssertFalse(sort1.canBeDisabled)
        
        let sort2 = Sort(sortType: .DateAscending)
        XCTAssertFalse(sort2.canBeDisabled)
        
        let sort3 = Sort(sortType: .DateDescending)
        XCTAssertFalse(sort3.canBeDisabled)
        
        let sort4 = Sort(sortType: .DistanceAscending)
        XCTAssertTrue(sort4.canBeDisabled)
        
        let sort5 = Sort(sortType: .DistanceDescending)
        XCTAssertTrue(sort5.canBeDisabled)
    }
    
    func testHint() {
        var sort1 = Sort(sortType: .DistanceAscending)
        XCTAssert(sort1.hint == "Tap to select")
        
        sort1.isEnabled = false
        XCTAssert(sort1.hint == "Available after selecting a location")
        
        var sort2 = Sort(sortType: .DistanceDescending)
        XCTAssert(sort2.hint == "Tap to select")
        
        sort2.isEnabled = false
        XCTAssert(sort2.hint == "Available after selecting a location")
    }
}
