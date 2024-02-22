//
//  PetTests.swift
//  PetsTests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest
@testable import Pets

class PetTests: XCTestCase {
    let pet = MockConstants.PetMock.pet
    
    func testFormattedName() {
        XCTAssertEqual(pet.formattedName, "Phoenix") // #70799220")
    }
    
    func testSpeciesGender() {
        XCTAssertEqual(pet.speciesGender, "Cat • Male • Adult")
    }
    
    func testPublished() {
        XCTAssertEqual(pet.published, "14:16 • 21 Feb, 2024")
    }
    
    func testFormattedPublished() {
        XCTAssertEqual(pet.formattedPublished, "14:16\n21 Feb, 2024")
    }
    
    func testFormattedDistance() {
        XCTAssertEqual(pet.formattedDistance, "43.5 miles away")
    }
}
