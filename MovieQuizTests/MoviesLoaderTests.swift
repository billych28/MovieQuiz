//
//  MoviesLoaderTests.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 16.03.2026.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClientMock(emulateError: false)
        let sut = MoviesLoader(networkClient: stubNetworkClient)
            
        // When
        let expectation = expectation(description: "Loading expectation")
        
        sut.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
        
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClientMock(emulateError: true)
        let sut = MoviesLoader(networkClient: stubNetworkClient)
            
        // When
        let expectation = expectation(description: "Loading expectation")
        
        sut.loadMovies { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
