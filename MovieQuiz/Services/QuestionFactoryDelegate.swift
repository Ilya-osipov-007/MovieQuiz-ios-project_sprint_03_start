//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Геннадьевич on 06.01.2026.
//
protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
