//
//  MYCalculatorTests.swift
//  MYCalculatorTests
//
//  Created by 刘景州 on 2018/8/26.
//  Copyright © 2018年 刘景州. All rights reserved.
//

import XCTest
@testable import MYCalculator

class MYCalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAction1() {
        let calculatorArray = ["3", "+", "-6", "x", "9"]
        
        let calculatorString = Calculator.exchangeCalculateArrayToString(array: calculatorArray)
        XCTAssertEqual(calculatorString, "3+m6x9", "结果错误")
    }
    
    func testAction2() {
        let calculatorArray = ["3", "x", "-6", "/", "0"]
        let divisorIsZero = Calculator.judgeDivisorIsEqualZero(numberArray: calculatorArray)
        XCTAssertEqual(divisorIsZero, true, "结果错误")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
