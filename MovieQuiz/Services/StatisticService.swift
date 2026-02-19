//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.02.2026.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    // MARK: - Public properties
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameResult {
        get {
            let correctAnswers = storage.integer(
                forKey: Keys.bestGameCorrect.rawValue
            )
            let totalQuestions = storage.integer(
                forKey: Keys.bestGameTotal.rawValue
            )
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(
                correctAnswers: correctAnswers,
                totalQuestions: totalQuestions,
                date: date
            )
        }
        set {
            let correctAnswers = newValue.correctAnswers
            let totalQuestions = newValue.totalQuestions
            let date = newValue.date
            
            storage.set(correctAnswers, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(totalQuestions, forKey: Keys.bestGameTotal.rawValue)
            storage.set(date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    var totalAccuracy: Double {
        get {
            if totalQuestionsAsked <= 0 { return 0 }
            return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
        }
    }
    
    // MARK: - Private properties
    private let storage: UserDefaults = .standard
    
    private var totalCorrectAnswers: Int {
        get {
            return storage
                .integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    private var totalQuestionsAsked: Int {
        get {
            return storage
                .integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    // MARK: - Public methods
    func store(correctAnswers: Int, totalQuestions: Int) {
        gamesCount += 1
        totalCorrectAnswers += correctAnswers
        totalQuestionsAsked += totalQuestions
        
        let currentGame = GameResult(
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            date: Date()
        )
        bestGame = currentGame
            .isBetterThan(result: bestGame) ? currentGame : bestGame
    }
}

private enum Keys: String {
    case gamesCount
    case bestGameCorrect
    case bestGameTotal
    case bestGameDate
    case totalCorrectAnswers
    case totalQuestionsAsked
}
