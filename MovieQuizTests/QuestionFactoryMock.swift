//
//  StubQuestionFactory.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 18.03.2026.
//
@testable import MovieQuiz

final class QuestionFactoryMock: QuestionFactoryProtocol {
    var requestNextQuestionCalled = false
    var loadDataCalled = false
    
    func requestNextQuestion() {
        requestNextQuestionCalled = true
    }
    
    func loadData() {
        loadDataCalled = true
    }
}
