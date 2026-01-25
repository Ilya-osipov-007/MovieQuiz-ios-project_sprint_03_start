//
//  QuizAlertModel.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 10.01.2026.
//
import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    // Замыкание без параметров для действия по кнопке алерта completion.
    var completion: () -> Void // Что делать при нажатии на кнопку
}

// замыкание без параметров для действия по кнопке алерта completion.
