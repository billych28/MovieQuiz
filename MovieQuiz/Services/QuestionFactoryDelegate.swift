//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 17.02.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
