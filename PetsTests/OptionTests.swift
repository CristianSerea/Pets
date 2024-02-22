//
//  OptionTests.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest
@testable import Pets

class OptionTests: XCTestCase {
    func testTitleWithSort() {
        let sort = Sort(sortType: .DateShuffled)
        let option = Option(sort: sort, filter: nil)
        XCTAssertEqual(option.title, "Date shuffled")
    }
    
    func testTitleWithFilter() {
        let filter = Filter(filterType: .Gender)
        let option = Option(sort: nil, filter: filter)
        XCTAssertEqual(option.title, "Gender")
    }
}
