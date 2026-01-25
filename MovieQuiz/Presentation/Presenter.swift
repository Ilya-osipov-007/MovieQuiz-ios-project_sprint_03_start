//
//  Presenter.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 15.01.2026.
//

import UIKit

final class Presenter: PresenterProtocol {
    var currentQuestionIndex = 0
    var correctAnswers = 0
    let questionsAmount = 10
    
    func makeResultsMessage() -> String {
        return "Вы ответили на \(correctAnswers) из \(questionsAmount)"
    }
    
    func restartGame() {
        // ПРОСТО СБРАСЫВАЕМ СОСТОЯНИЕ, КАК ЭТО БЫЛО В КОНТРОЛЛЕРЕ РАНЬШЕ
        currentQuestionIndex = 0
        correctAnswers = 0
        
    }

    
    // Методы для управления состоянием
    func incrementCorrectAnswers() {
        correctAnswers += 1
    }
    
    func resetCorrectAnswers() {
        correctAnswers = 0
    }
}


