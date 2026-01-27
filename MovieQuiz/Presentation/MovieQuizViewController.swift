import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private let presenter = Presenter()
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    // приватный метод, который и меняет цвет рамки, и вызывает метод перехода
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        // ВАЖНО: увеличиваем счетчик правильных ответов
        if isCorrect {
            presenter.incrementCorrectAnswers()
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // слабая ссылка на self
            guard let self = self else { return } // разворачиваем слабую ссылку
            self.showNextQuestionOrResults()
        }
    }
    
    
    // Приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if presenter.currentQuestionIndex == questionsAmount - 1 {
            let text = presenter.correctAnswers == 10 ?
                    "Поздравляем, вы ответили на 10 из 10!" :
                    "Вы ответили на \(presenter.correctAnswers) из 10, попробуйте ещё раз!" // 1
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
        } else {
            presenter.currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // метод вызывается, когда пользователь нажимает на кнопку "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }  // 1
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    
    // метод вызывается, когда пользователь нажимает на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }  // 1
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    // Общее количество вопросов для квиза
    private let questionsAmount: Int = 10
    // Фабрика вопросов. Контроллер будет обращаться за вопросами к ней
    private var questionFactory: QuestionFactoryProtocol?
    // Вопрос, который видит пользователь, опциоанльный т.к. может и не быть
    private var currentQuestion: QuizQuestion?
    // Показ алерта презентер
    
    
    
    // при первом запуске экрана
    override func viewDidLoad() {
        super.viewDidLoad()
        // Сбрасываем рамку и ее цвет при запуске
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        // Задаем закругление рамки при запуске
        imageView.layer.cornerRadius = 20
        // Включаем кнопки при запуске
        enableButtons()
        
        // questionFactory = QuestionFactory(delegate: self)
        
        let questionFactory = QuestionFactory()
        // Назначаем себя делегатом, чтобы получать вопросы обратно
        questionFactory.delegate = self
        // Сохраняем фабрику, чтобы вызывать её дальше
        self.questionFactory = questionFactory

        // Запрашиваем первый вопрос у фабрики
        questionFactory.requestNextQuestion()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        // Делегат получил вопрос и обновляет UI
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        // Сбрасываем рамку перед показом нового вопроса
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        // Включаем кнопки перед показом нового вопроса
        enableButtons()
        
        imageView.image = step.image
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
        statisticService.store(correct: presenter.correctAnswers, total: questionsAmount)
        let bestGame = statisticService.bestGame
        let message = """
Ваш результат: \(presenter.correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            // Вызываем метод презентера
            self.presenter.restartGame()
            // ВСЯ ОСТАЛЬНАЯ ЛОГИКА ПЕРЕЗАПУСКА, КОТОРАЯ УЖЕ РАБОТАЛА РАНЬШЕ:
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = nil
            self.enableButtons()
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(presenter.currentQuestionIndex + 1)/\(questionsAmount)"
        ) // 4
        return questionStep
    }
    
    
}
