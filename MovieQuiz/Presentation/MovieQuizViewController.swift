import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private var presenter = MovieQuizPresenter()
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // метод вызывается, когда пользователь нажимает на кнопку "Да"
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    func hideLoadingIndicator() {
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    // метод вызывается, когда пользователь нажимает на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    // Фабрика вопросов. Контроллер будет обращаться за вопросами к ней
    private var questionFactory: QuestionFactoryProtocol?
    // Вопрос, который видит пользователь, опциоанльный т.к. может и не быть
    private var currentQuestion: QuizQuestion?
    // Показ алерта презентер
    
    
    
    // при первом запуске экрана
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        // Сбрасываем рамку и ее цвет при запуске
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        // Задаем закругление рамки при запуске
        imageView.layer.cornerRadius = 20
        // Включаем кнопки при запуске
        enableButtons()
    }

    
    
    func show(quiz step: QuizStepViewModel) {
        // Сбрасываем рамку перед показом нового вопроса
        imageView.layer.borderWidth = 0
        // Включаем кнопки перед показом нового вопроса
        enableButtons()
        
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    // Приватный метод для показа алерта с результатами квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
    
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            // Вызываем метод презентера
            self.presenter.restartGame()
            // ВСЯ ОСТАЛЬНАЯ ЛОГИКА ПЕРЕЗАПУСКА, КОТОРАЯ УЖЕ РАБОТАЛА РАНЬШЕ:
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = nil
            self.enableButtons()
        }
        
        alertPresenter.show(in: self, model: model)
    }

}
