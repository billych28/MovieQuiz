//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 17.03.2026.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuestion(quiz step: QuizStepViewModel)
    func showResult(result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func setButtonsIsEnabled(isEnabled: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkErrorAlert(message: String)
}
