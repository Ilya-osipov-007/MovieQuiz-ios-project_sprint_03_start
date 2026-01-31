//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 16.01.2026.
//
import UIKit

final class StatisticService {
    private let storage: UserDefaults = .standard

    private enum Keys: String {
    case gamesCount          // Для счётчика сыгранных игр
    case bestGameCorrect     // Для количества правильных ответов в лучшей игре
    case bestGameTotal       // Для общего количества вопросов в лучшей игре
    case bestGameDate        // Для даты лучшей игры
    case totalCorrectAnswers // Для общего количества правильных ответов за все игры
    case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
}
    // или реализуем протокол с помощью расширения
extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            // Добавьте чтение значения из UserDefaults
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            // Добавьте запись значения newValue в UserDefaults
            storage.set(newValue, forKey:  Keys.gamesCount.rawValue)
        }
    }
    
    
    
    var bestGame: GameResult {
        get {
            // Добавьте чтение значений полей GameResult(correct, total и date) из UserDefaults,
            // затем создайте GameResult от полученных значений
            
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            // Добавьте запись значений каждого поля из newValue в UserDefaults
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    
    
    private var totalCorrectAnswers: Int {
        get { storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue) }
    }
    
    
    private var totalQuestionsAsked: Int {
        get { storage.integer(forKey: Keys.totalQuestionsAsked.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue) }
    }
    
    
    
    var totalAccuracy: Double {
        if totalQuestionsAsked == 0 { return 0 }
        // отношение общего числа правильных ответов
        // // ко всем заданным вопросам за все игры
        return ( Double(totalCorrectAnswers) / Double(totalQuestionsAsked) ) * 100
    }
    
    
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if newGame.isBetterThan(bestGame) {
            bestGame = newGame
        }
    }
}
