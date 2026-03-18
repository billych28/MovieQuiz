//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 16.03.2026.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let array = [1, 2, 3, 3, 4, 5]
           
        // When
        let result = array[safe: 4]
           
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 4)
    }
        
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 2, 3]
           
        // When
        let result = array[safe: 3]
           
        // Then
        XCTAssertNil(result)
    }
}
