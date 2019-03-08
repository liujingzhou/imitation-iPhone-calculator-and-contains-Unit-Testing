//
//  MYCalculatorUITests.swift
//  MYCalculatorUITests
//
//  Created by 刘景州 on 2018/8/26.
//  Copyright © 2018年 刘景州. All rights reserved.
//

import XCTest

class MYCalculatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample1() {
        //用户输入表达式：[3] [+] [6] [x] [9] [=]
        
        let app = XCUIApplication()
        app.buttons["AC"].tap()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["×"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        
        let resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "57", "xxx")
    }
    
    func testExample2() {
        //用户输入表达式：[x] [1] [2] [4] [=]
        
        let app = XCUIApplication()
        app.buttons["AC"].tap()
        app.buttons["×"].tap()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        
        let resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "0", "xxx")
    }
    
    func testExample3() {
        //用户输入表达式：[8] [+/-] [x] [9] [+/-] [-] [1] [x] [5]
        
        let app = XCUIApplication()
        app.buttons["AC"].tap()
        app.buttons["8"].tap()
        let button = app.buttons["+/-"]
        button.tap()
        let button2 = app.buttons["×"]
        button2.tap()
        app.buttons["9"].tap()
        button.tap()
        let button3 = app.buttons["-"]
        button3.tap()
        app.buttons["1"].tap()
        button2.tap()
        app.buttons["5"].tap()
        button3.tap()
        
        let resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "67", "xxx")
    }
    
    func testExample4() {
        //用户输入表达式：[9] [9] [9] [9] [9] [9] [9] [9] [9] [9] [9] [x] [=]
        
        let app = XCUIApplication()
        app.buttons["AC"].tap()
        let button = app.buttons["9"]
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        var resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "999999999", "xxx")
        
        app.buttons["×"].tap()
        button.tap()
        app.buttons["="].tap()
        app.alerts["提示"].buttons["好的"].tap()
        
        resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "0", "xxx")
    }
    
    func testExample5() {
        //用户输入表达式：[9] [x] [3] [.] [6] [-] [8] [/] [2] [.] [.] [3] [0]
        
        let app = XCUIApplication()
        app.buttons["9"].tap()
        app.buttons["×"].tap()
        let button = app.buttons["3"]
        button.tap()
        let button2 = app.buttons["."]
        button2.tap()
        app.buttons["6"].tap()
        app.buttons["-"].tap()
        app.buttons["8"].tap()
        app.buttons["÷"].tap()
        app.buttons["2"].tap()
        button2.tap()
        button2.tap()
        button.tap()
        app.buttons["0"].tap()
        app.buttons["="].tap()
        
        let resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "28.921739", "xxx")
    }
    
    func testExample6() {
        //用户输入表达式：[0] [.] [0] [0] [1] [2] [%] [+] [3] [=]
        
        let app = XCUIApplication()
        let button = app.buttons["0"]
        button.tap()
        app.buttons["."].tap()
        button.tap()
        button.tap()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["%"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        
        let resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "3.000012", "xxx")
    }
    
    func testExample7() {
        //用户输入表达式：[3] [+] [-] [x] [/] [-] [6] [=]
        
        let app = XCUIApplication()
        app.buttons["AC"].tap()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        let button = app.buttons["-"]
        button.tap()
        app.buttons["×"].tap()
        app.buttons["÷"].tap()
        button.tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        
        let resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "-3", "xxx")
    }
    
    func testExample8() {
        //用户输入表达式：[3] [.] [4] [x] [/] [-] [6] [+] [7] [=] [/] [0] [=]
        
        let app = XCUIApplication()
        app.buttons["AC"].tap()
        app.buttons["3"].tap()
        app.buttons["."].tap()
        app.buttons["4"].tap()
        app.buttons["×"].tap()
        
        let button = app.buttons["÷"]
        button.tap()
        app.buttons["-"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["7"].tap()
        
        let button2 = app.buttons["="]
        button2.tap()
        button.tap()
        app.buttons["0"].tap()
        button2.tap()
        app.alerts["提示"].buttons["好的"].tap()
        
        let resultlabelStaticText = app.staticTexts["resultLabel"].value as! String
        XCTAssertEqual(resultlabelStaticText, "0", "xxx")
    }
    
}
