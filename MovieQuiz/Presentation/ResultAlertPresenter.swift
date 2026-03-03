//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 17.02.2026.
//

import UIKit

final class ResultAlertPresenter {
    func show(controller vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default
        ) { _ in
            model.completion()
        }

        alert.addAction(action)

        vc.present(alert, animated: true, completion: nil)
    }
}
