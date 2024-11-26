//
//  QuizReuslt.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-17.
//


import Foundation

struct QuizResult: Codable {
    var responses: [String]
    var resultAnswer: String
    var definition: String
}

