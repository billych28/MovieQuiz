import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private let presenter = MovieQuizPresenter()
    private var alertPresenter = ResultAlertPresenter()
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        imageView.layer.masksToBounds = true
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.submitAnswer(userAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.submitAnswer(userAnswer: true)
    }
    
    // MARK: - Public methods
    func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypWhite.cgColor
        imageView.layer.borderWidth = 0
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func setButtonsIsEnabled(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func showResult(result: QuizResultsViewModel) {
        let model = AlertModel(
            title: result.title,
            message: result.message,
            buttonText: result.buttonText,
        ) { [weak self] in
            guard let self else { return }
            presenter.restartQuiz()
        }
        alertPresenter.show(controller: self, model: model)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkErrorAlert (message: String) {
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Повторить"
        ) { [weak self] in
            guard let self else { return }
            
            presenter.startQuiz()
        }
        alertPresenter.show(controller: self, model: model)
    }
}
