//
//  QuestionPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 15.01.2026.
//
protocol PresenterProtocol {
    func makeResultsMessage(correctAnswers: Int) -> String
    func restartGame(currentQuestionIndex: inout Int, correctAnswers: inout Int)
    // Добавьте другие методы по мере необходимости
}
