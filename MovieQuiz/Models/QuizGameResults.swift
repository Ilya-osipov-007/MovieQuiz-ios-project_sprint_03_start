//
//  QuizGameResults.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 16.01.2026.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
