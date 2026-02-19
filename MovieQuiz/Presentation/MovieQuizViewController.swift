import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    private let questionsAmount = 10
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private var alertPresenter = ResultAlertPresenter()
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        imageView.layer.masksToBounds = true
        startQuiz()
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        onButtonClick(sender: sender, userAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        onButtonClick(sender: sender, userAnswer: true)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showQuestion(quiz: viewModel)
        }
    }
    
    // MARK: - Private Methods
    private func startQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypWhite.cgColor
        imageView.layer.borderWidth = 0
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService
                .store(
                    correctAnswers: correctAnswers,
                    totalQuestions: questionsAmount
                )
            let viewModel = getGameResult()
            showResult(result: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func getGameResult() -> QuizResultsViewModel {
        let date = Date()
        let bestCorrectAnswersCount = statisticService.bestGame.correctAnswers
        let currentPersonalRecord = "\(bestCorrectAnswersCount)/\(statisticService.bestGame.totalQuestions) (\(date.dateTimeString))"
        let message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(currentPersonalRecord)
        Средняя точность: \(statisticService.totalAccuracy.twoDigitPrecisionString)%
        """
        
        let viewModel = QuizResultsViewModel(
            title:"Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз")
        
        return viewModel
    }
    
    private func showResult(result: QuizResultsViewModel) {
        let model = AlertModel(
            title: result.title,
            message: result.message,
            buttonText: result.buttonText,
        ) { [weak self] in
            guard let self = self else { return }
            self.startQuiz()
        }
        alertPresenter.show(controller: self, model: model)
    }
    
    private func onButtonClick(sender: UIButton, userAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let correctAnswer = currentQuestion.correctAnswer
        sender.isEnabled = false
        showAnswerResult(isCorrect: userAnswer == correctAnswer)
    }
}
