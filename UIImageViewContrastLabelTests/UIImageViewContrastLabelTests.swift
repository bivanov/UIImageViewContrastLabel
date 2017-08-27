//
//  UIImageViewContrastLabelTests.swift
//  UIImageViewContrastLabelTests
//
//  Created by Bohdan Ivanov on 19.08.17.
//  Copyright © 2017 bivanov. All rights reserved.
//

import XCTest
@testable import UIImageViewContrastLabel

class UIImageViewContrastLabelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContrastLabelLayerCreation() {
        let layer = CAContrastLabelLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        let textPosition = layer.textPosition
        
        XCTAssert(textPosition == CGPoint.zero,
                  "Initial text position should be (0.0, 0.0), got \(textPosition)")
    }
    
    func testContrastLabelLayerValidPosition() {
        let layer = CAContrastLabelLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.textPosition = CGPoint(x: 0.5, y: 0.5)
        
        XCTAssert(fabs(layer.textPosition.x - 0.5) < 0.01,
                  "Text position x should be 0.5, got \(layer.textPosition.x)")
        XCTAssert(fabs(layer.textPosition.y - 0.5) < 0.01,
                  "Text position y should be 0.5, got \(layer.textPosition.y)")
    }
    
    func testContrastLabelLayerInvalidPosition() {
        let layer = CAContrastLabelLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.textPosition = CGPoint(x: 0.7, y: 0.8)
        
        layer.textPosition = CGPoint(x: 24.0, y: 0.1)
        
        XCTAssert(fabs(layer.textPosition.x - 0.7) < 0.01,
                  "Text position x should be 0.7, got \(layer.textPosition.x)")
        XCTAssert(fabs(layer.textPosition.y - 0.8) < 0.01,
                  "Text position y should be 0.8, got \(layer.textPosition.y)")
    }
}
