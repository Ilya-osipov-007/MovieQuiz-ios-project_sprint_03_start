//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 03.01.2026.
//

import UIKit

// метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}

