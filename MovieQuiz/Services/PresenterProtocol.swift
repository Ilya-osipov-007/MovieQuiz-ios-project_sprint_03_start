//
//  PresenterProtocol.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 15.01.2026.
//
import UIKit

protocol PresenterProtocol: AnyObject {
    var currentQuestionIndex: Int { get set }
    var correctAnswers: Int { get set }
    var questionsAmount: Int { get }
    
    func makeResultsMessage() -> String
    func restartGame()
}
