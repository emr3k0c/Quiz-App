//
//  Quiz.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation

struct Quiz: Codable {
    var score: String
    var questions: [Question]
    var selectedAnswers: [String: String]

    func toDictionary() -> [String: Any] {
            let questionsDict = questions.map { $0.toDictionary() }
            return [
                "score": score,
                "questions": questionsDict,
                "selectedAnswers": selectedAnswers
            ]
    }
}
