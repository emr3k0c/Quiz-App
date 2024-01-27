//
//  Question.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation

struct Question: Codable, Hashable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]

    func toDictionary() -> [String: Any] {
            return [
                "type": type,
                "difficulty": difficulty,
                "category": category,
                "question": question,
                "correct_answer": correct_answer,
                "incorrect_answers": incorrect_answers
            ]
        }

    func decodedHTMLString() -> Question {
        do {
            let attributedQuestion = try AttributedString(markdown: self.question)
            let attributedCorrectAnswer = try AttributedString(markdown: self.correct_answer)
            let attributedIncorrectAnswers = try incorrect_answers.map { answer in
                try AttributedString(markdown: answer) }

            let plainQuestion = String(attributedQuestion.characters)
            let plainCorrectAnswer = String(attributedCorrectAnswer.characters)
            let plainIncorrectAnswers = attributedIncorrectAnswers.map { String($0.characters) }

            return Question(type: self.type, difficulty: self.difficulty,
                            category: self.category, question: plainQuestion,
                            correct_answer: plainCorrectAnswer, incorrect_answers: plainIncorrectAnswers)
        } catch {
            print("Error decoding HTML: \(error)")
            return self
        }
    }
}
