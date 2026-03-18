//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Мамытов Руслан on 16.03.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    @MainActor
    func testYesButton() throws {
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    @MainActor
    func testNoButton() throws {
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    @MainActor
    func testGameResultsAlertShow() throws {
        sleep(3)
        
        let yesButton = app.buttons["Yes"]
        for _ in 0..<10 {
            yesButton.tap()
            sleep(3)
        }
                
        let alert = app.alerts["Alert"]
        let alertLabel = alert.label
        let alertAction = alert.buttons.firstMatch.label
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alertLabel, "Этот раунд окончен!")
        XCTAssertEqual(alertAction, "Сыграть ещё раз")
    }
    
    @MainActor
    func testGameResultsAlertDismiss() throws {
        sleep(3)
        
        let yesButton = app.buttons["Yes"]
        for _ in 0..<10 {
            yesButton.tap()
            sleep(3)
        }
                
        let alert = app.alerts["Alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
