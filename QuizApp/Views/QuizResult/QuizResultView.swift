//
//  QuizResultView.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI

struct QuizResultView: View {

    @StateObject private var viewModel: QuizResultViewModel

    init(quizId: String, user: User) {
        _viewModel = StateObject(wrappedValue: QuizResultViewModel(quizId: quizId, user: user))
    }

    var body: some View {
        List(viewModel.questions, id: \.self) { question in
            VStack(alignment: .leading, spacing: 10) {
                Text(question.question)
                    .fontWeight(.bold)
                ForEach(viewModel.questionOptions[question.question] ?? [], id: \.self) { answer in
                    Text(answer)
                        .background(decideColoring(for: answer, question: question))
                        .cornerRadius(5)
                }

            }
            .navigationTitle("RESULT: \(viewModel.user.quizzes[viewModel.quizId]?.score ?? "")")
            .listRowBackground(Color.purple.opacity(0.2))
        }
    }
    func decideColoring(for answer: String, question: Question) -> Color {
        let userAnswer = viewModel.selectedAnswers[question.question]
        if answer == question.correct_answer {
            return Color.green.opacity(0.5)
        } else if answer == userAnswer {
            return Color.red.opacity(0.5)
        } else {
            return Color.clear
        }
    }
}

#Preview {
    QuizResultView(quizId: "4354", user:
                    User(uid: "gsdfg", username: "fs", profileImageUrl: "", quizzes: [:], points: 5))
}
