//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 17.02.2026.
//

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
