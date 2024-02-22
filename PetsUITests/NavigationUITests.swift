//
//  NavigationUITests.swift
//  PetsUITests
//
//  Created by Cristian Serea on 22.02.2024.
//

import XCTest

final class NavigationUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testPets() {
        let petsTitle = app.navigationBars["Pets 🐶"]
        XCTAssertTrue(petsTitle.waitForExistence(timeout: 3))
    }
    
    func testTransitionFromPetsToSettings() {
        let petsTitle = app.navigationBars["Pets 🐶"]
        let settingsBarButton = app.navigationBars.buttons["slider.vertical.3"]
        XCTAssertTrue(petsTitle.waitForExistence(timeout: 3))
        XCTAssertTrue(settingsBarButton.waitForExistence(timeout: 3))
        
        settingsBarButton.tap()
        
        let settingsTitle = app.navigationBars["Sort & Filter"]
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 5))
    }
    
    func testTransitionFromPetsToSettingsAndBackToPets() {
        let petsTitle = app.navigationBars["Pets 🐶"]
        let settingsBarButton = app.navigationBars.buttons["slider.vertical.3"]
        XCTAssertTrue(petsTitle.waitForExistence(timeout: 3))
        XCTAssertTrue(settingsBarButton.waitForExistence(timeout: 3))
        
        settingsBarButton.tap()
        
        let settingsTitle = app.navigationBars["Sort & Filter"]
        let backBarButton = app.navigationBars.buttons.element(boundBy: .zero)
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 5))
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 5))
        
        backBarButton.tap()
        
        let currentTitle = app.navigationBars.staticTexts.element(boundBy: .zero)
        XCTAssert(currentTitle.waitForExistence(timeout: 8))
        XCTAssertEqual(currentTitle.label, petsTitle.identifier)
    }
}
