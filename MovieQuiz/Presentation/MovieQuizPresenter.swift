//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 17.03.2026.
//
import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Public properties
    let questionsAmount = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    
    // MARK: - Private properties
    private let statisticService: StatisticServiceProtocol
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    
    // MARK: - Initialization
    init(
        viewController: MovieQuizViewControllerProtocol? = nil,
        statisticService: StatisticServiceProtocol = StatisticService(),
        questionFactory: QuestionFactoryProtocol? = nil,
    ) {
        self.viewController = viewController
        self.statisticService = statisticService
        
        if let questionFactory = questionFactory {
            self.questionFactory = questionFactory
        } else {
            self.questionFactory = QuestionFactory(
                moviesLoader: MoviesLoader(),
                delegate: self
            )
        }
        
        startQuiz()
    }
    
    // MARK: - Public methods
    func startQuiz() {
        resetQuestionIndexAndCorrectAnswers()
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        viewController?.hideLoadingIndicator()
        viewController?
            .showNetworkErrorAlert(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            viewController?.showQuestion(quiz: viewModel)
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.imageData,
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
    }
    
    func submitAnswer(userAnswer: Bool) {
        guard let currentQuestion else { return }
        
        viewController?.setButtonsIsEnabled(isEnabled: false)
    
        let isCorrectAnswer = userAnswer == currentQuestion.correctAnswer
        if isCorrectAnswer {
            correctAnswers += 1
        }
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrectAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            viewController?.setButtonsIsEnabled(isEnabled: true)
            showNextQuestionOrResults()
        }
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            statisticService
                .store(
                    correctAnswers: correctAnswers,
                    totalQuestions: questionsAmount
                )
            let viewModel = getGameResult()
            viewController?.showResult(result: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    func restartQuiz() {
        resetQuestionIndexAndCorrectAnswers()
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Private methods
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func resetQuestionIndexAndCorrectAnswers() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func getGameResult() -> QuizResultsViewModel {
        statisticService
            .store(
                correctAnswers: correctAnswers,
                totalQuestions: questionsAmount
            )
        
        let bestGame = statisticService.bestGame
        let currentPersonalRecord = "\(bestGame.correctAnswers)/\(bestGame.totalQuestions) (\(bestGame.date.dateTimeString))"
        let message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(currentPersonalRecord)
        Средняя точность: \(statisticService.totalAccuracy.twoDigitPrecisionString)%
        """
        
        let viewModel = QuizResultsViewModel(
            title:"Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз")
        
        return viewModel
    }
}
