// MovieUITests.swift
// Copyright © RoadMap. All rights reserved.


import CoreData
@testable import Movie
import XCTest

class MovieUITests: XCTestCase {

    var application: XCUIApplication!
    
    let overview = """
    Эдди живёт с симбиотом в своём теле уже давно и приспособился к быту. Однако ему придётся столкнуться со злодеем Клетусом Кэссиди, в котором обитает другой внеземной паразит по прозвищу Карнаж.
    """
    let title = "Веном 2"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        application = XCUIApplication()
        application.launchArguments.append("ClearDB")
        application.launch()
     
    }

    func testExample() throws {
         application = XCUIApplication()
        let cell = application.tables.cells.containing(.cell, identifier: "0")
        let textLabel = cell.staticTexts.element(boundBy: 0).label
        XCTAssertEqual(textLabel, overview)
        cell.staticTexts.element(boundBy: 0).tap()
        let movieTitleText = application.staticTexts.element(boundBy: 0).label
        XCTAssertEqual(movieTitleText, title)
    }
}
