//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Мамытов Руслан on 17.02.2026.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    // MARK: - Private properties
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    // MARK: - Initializers
    init(
        moviesLoader: MoviesLoading,
        delegate: QuestionFactoryDelegate? = nil
    ) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageUrl)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
                    
            let question = convertQuizQuestion(
                imageData: imageData,
                rating: rating
            )
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let movies):
                    self.movies = movies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    // MARK: - Private methods
    private func convertQuizQuestion(imageData: Data, rating: Float) -> QuizQuestion {
        let ratingInt = Int(rating.rounded())
        let randomInt = Int.random(in: 3...9)
        let questionType = QuizQuestionType.allCases.randomElement() ?? .greater
    
        let (text, correctAnswer) = switch questionType {
        case .greater:
            (
                "Рейтинг этого фильма больше чем \(randomInt)?",
                ratingInt > randomInt
            )
        case .less:
            (
                "Рейтинг этого фильма меньше чем \(randomInt)?",
                ratingInt < randomInt
            )
        case .equal:
            (
                "Рейтинг этого фильма равен \(randomInt)?",
                ratingInt == randomInt
            )
        }
        
        return QuizQuestion(
            imageData: imageData,
            text: text,
            correctAnswer: correctAnswer
        )
    }
}
