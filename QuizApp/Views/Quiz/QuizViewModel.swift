//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Emre Koç on 11.01.2024.
//

import Foundation
import FirebaseFirestore

class QuizViewModel: ObservableObject {
    @Published var isLoading = true
    private var dataSource = QuizDataSource()
    @Published var questionList: [Question] = []
    @Published var selectedAnswers: [String: String] = [:]
    @Published var user: User
    @Published var questionsAndAnswers: [String: [String]] = [:]
    @Published var quizId: String = UUID().uuidString

    init(user: User) {
        self.user = user
        dataSource.delegate = self
    }

    func loadQuestions(numberOfQuestions: Int, difficulty: String, category: Int) {
        dataSource.loadQuestionList(amount: numberOfQuestions, category: category, difficulty: difficulty)
    }

    func submitQuiz() {
        var numOfCorrectAnswers = 0
        for question in questionList {
            if question.correct_answer == selectedAnswers[question.question] {
                numOfCorrectAnswers += 1
            }
        }
        self.user.quizzes[quizId] = Quiz(
            score: "\(numOfCorrectAnswers)/\(questionList.count)",
            questions: questionList,
            selectedAnswers: selectedAnswers)
        print(self.user.points)
        self.user.points += numOfCorrectAnswers
        print(self.user.points)

        let database = Firestore.firestore()
        let userRef = database.collection("users").document(self.user.uid)
        userRef.updateData([
            "quizzes": self.user.quizzes.mapValues { $0.toDictionary() },
            "points": self.user.points]) { error in
            if let error = error {
                print("Error updating quizzes/points in Firestore: \(error)")
            } else {
                print("Quizzes/Points updated successfully.")
            }
        }
    }
}

extension QuizViewModel: QuizDataSourceDelegate {

    func questionListLoaded(questionList: [Question]) {
        isLoading = false
        self.questionList = questionList
        for question in questionList {
            let questionOptions = question.incorrect_answers + [question.correct_answer].shuffled()
            self.questionsAndAnswers[question.question] = questionOptions
            }
    }
}
