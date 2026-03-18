//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.03.2026.
//
import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    
    private enum TestError: Error, LocalizedError {
        case connectionFailed
        
        var errorDescription: String? {
            return "Сеть недоступна"
        }
    }
    
    func testStartQuiz() throws {
        // Given
        let viewControllerMock = MovieQuizViewControllerMock()
        let questionFactoryMock = QuestionFactoryMock()
        let sut = MovieQuizPresenter(
            viewController: viewControllerMock,
            questionFactory: questionFactoryMock
        )
        
        // When
        sut.startQuiz()
        
        // Then
        XCTAssertTrue(viewControllerMock.showLoadingIdicatorCalled)
        XCTAssertTrue(questionFactoryMock.loadDataCalled)
    }
    
    func testDidLoadDataFromServer() throws {
        // Given
        let viewControllerMock = MovieQuizViewControllerMock()
        let questionFactoryMock = QuestionFactoryMock()
        let sut = MovieQuizPresenter(
            viewController: viewControllerMock,
            questionFactory: questionFactoryMock
        )
        
        // When
        sut.didLoadDataFromServer()
        
        // Then
        XCTAssertTrue(viewControllerMock.hideLoadingIndicatorCalled)
        XCTAssertTrue(questionFactoryMock.requestNextQuestionCalled)
    }
    
    func testDidFailToLoadData() throws {
        // Given
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        // When
        sut.didFailToLoadData(with: TestError.connectionFailed)
        
        // Then
        XCTAssertTrue(viewControllerMock.hideLoadingIndicatorCalled)
        XCTAssertEqual(
            viewControllerMock.networkErrorAlertMessage,
            "Сеть недоступна"
        )
    }
    
    func testConvert() throws {
        // Given
        let sut = MovieQuizPresenter()
                
        let emptyData = Data()
        let question = QuizQuestion(
            imageData: emptyData,
            text: "Question Text",
            correctAnswer: true
        )
        
        // When
        let viewModel = sut.convert(model: question)
               
        // Then
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
    
    func testShowNextQuestionOrResults() throws {
        // Given
        let questionFactoryMock = QuestionFactoryMock()
        let sut = MovieQuizPresenter(questionFactory: questionFactoryMock)
        
        // When
        sut.showNextQuestionOrResults()
        
        // Then
        XCTAssertTrue(questionFactoryMock.requestNextQuestionCalled)
    }
    
}
