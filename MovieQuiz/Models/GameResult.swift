//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.02.2026.
//

import Foundation

struct GameResult {
    let correctAnswers: Int
    let totalQuestions: Int
    let date: Date
    
    func isBetterThan(result: GameResult) -> Bool {
        self.correctAnswers >= result.correctAnswers
    }
}
