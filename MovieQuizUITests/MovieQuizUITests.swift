//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Илья Геннадьевич on 04.02.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    func testScreenCast() throws { }
    
    var app: XCUIApplication!
 

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false

        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testYesButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }
    
}
