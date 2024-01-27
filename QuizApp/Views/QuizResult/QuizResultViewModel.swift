//
//  QuizResultViewModel.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation

class QuizResultViewModel: ObservableObject {
    @Published var quizId: String
    @Published var user: User
    @Published var questions: [Question]
    @Published var selectedAnswers: [String: String]
    @Published var questionOptions: [String: [String]] = [:]

    init(quizId: String, user: User) {
        self.quizId = quizId
        self.user = user
        self.questions = user.quizzes[quizId]?.questions ?? []
        self.selectedAnswers = user.quizzes[quizId]?.selectedAnswers ?? [:]
        for question in user.quizzes[quizId]?.questions ?? [] {
            let questionOptions = question.incorrect_answers + [question.correct_answer].shuffled()
            self.questionOptions[question.question] = questionOptions
        }
    }

}
