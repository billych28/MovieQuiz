//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.03.2026.
//
import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    
    // MARK: - Properties
    
    private var viewControllerMock: MovieQuizViewControllerMock!
    private var questionFactoryMock: QuestionFactoryMock!
    private var sut: MovieQuizPresenter!
    
    private enum TestError: Error, LocalizedError {
        case connectionFailed
        
        var errorDescription: String? {
            return "Сеть недоступна"
        }
    }
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        viewControllerMock = MovieQuizViewControllerMock()
        questionFactoryMock = QuestionFactoryMock()
        sut = MovieQuizPresenter(
            viewController: viewControllerMock,
            questionFactory: questionFactoryMock
        )
    }
    
    override func tearDown() {
        viewControllerMock = nil
        questionFactoryMock = nil
        sut = nil
        
        super.tearDown()
    }
    
    func testStartQuiz() throws {
        // When
        sut.startQuiz()
        
        // Then
        XCTAssertTrue(viewControllerMock.showLoadingIdicatorCalled)
        XCTAssertTrue(questionFactoryMock.loadDataCalled)
    }
    
    func testDidLoadDataFromServer() throws {
        // When
        sut.didLoadDataFromServer()
        
        // Then
        XCTAssertTrue(viewControllerMock.hideLoadingIndicatorCalled)
        XCTAssertTrue(questionFactoryMock.requestNextQuestionCalled)
    }
    
    func testDidFailToLoadData() throws {
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
        // When
        sut.showNextQuestionOrResults()
        
        // Then
        XCTAssertTrue(questionFactoryMock.requestNextQuestionCalled)
    }
    
}
