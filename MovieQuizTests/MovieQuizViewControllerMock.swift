//
//  StubMovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.03.2026.
//
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var stepViewModel: QuizStepViewModel? = nil
    var resultViewModel: QuizResultsViewModel? = nil
    var showLoadingIdicatorCalled = false
    var hideLoadingIndicatorCalled = false
    var networkErrorAlertMessage = ""
    
    func showQuestion(quiz step: QuizStepViewModel) {
        stepViewModel = step
    }
    
    func showResult(result: QuizResultsViewModel) {
        resultViewModel = result
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func setButtonsIsEnabled(isEnabled: Bool) {
        
    }
    
    func showLoadingIndicator() {
        showLoadingIdicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func showNetworkErrorAlert(message: String) {
        networkErrorAlertMessage = message
    }
}
