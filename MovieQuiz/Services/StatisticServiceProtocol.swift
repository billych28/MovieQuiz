//
//  StatisticsServiceProtocol.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.02.2026.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correctAnswers: Int, totalQuestions: Int)
}
