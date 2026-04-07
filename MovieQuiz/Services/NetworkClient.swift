//
//  NetworkService.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 12.03.2026.
//
import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    // MARK: - Private properties
    private enum Constants {
        static let httpStatusCodeOk = 200
        static let httpStatusCodeRedirection = 300
    }

    private enum NetworkError: Error {
        case codeError
    }
    
    // MARK: - Public methods
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(
            with: request
        ) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < Constants.httpStatusCodeOk || response.statusCode >= Constants.httpStatusCodeRedirection {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
