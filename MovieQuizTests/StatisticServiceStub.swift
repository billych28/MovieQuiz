//
//  StatisticServiceMock.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.03.2026.
//
import Foundation
@testable import MovieQuiz

final class StatisticServiceStub: StatisticServiceProtocol {
    var gamesCount: Int = 0
    var bestGame: GameResult = GameResult(
        correctAnswers: 0,
        totalQuestions: 0,
        date: Date()
    )
    var totalAccuracy: Double = 0
    var storeIsCalled: Bool = false
    
    func store(correctAnswers: Int, totalQuestions: Int) {
        let game = GameResult(
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            date: Date()
        )
        bestGame = game
    }
}
