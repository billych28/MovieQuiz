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
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default
        ) { _ in
            model.completion()
        }

        action.accessibilityIdentifier = "Alert action"
        alert.addAction(action)

        vc.present(alert, animated: true, completion: nil)
    }
}
