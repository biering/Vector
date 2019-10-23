//
//  Vector2Tests.swift
//  
//
//  Created by Christoph Biering on 23.10.19.
//

import XCTest
@testable import Vector

final class Vector2Tests: XCTestCase {
    
    func testConstants() {
        XCTAssertEqual(Vector2.zero, Vector2(0, 0))
        XCTAssertEqual(Vector2.x, Vector2(1, 0))
        XCTAssertEqual(Vector2.y, Vector2(0, 1))
    }
    
    func testLengthSquared() {
        let vec = Vector2(3, 4)
        XCTAssertEqual(vec.lengthSquared, 25.0)
    }
    
    func testLength() {
        let vec = Vector2(3, 4)
        XCTAssertEqual(vec.length, 5.0)
    }

    static var allTests = [
        ("testConstants", testConstants),
        ("testLengthSquared", testLengthSquared),
        ("testLength", testLength)
    ]
}
