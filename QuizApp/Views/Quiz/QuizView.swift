//
//  QuizView.swift
//  QuizApp
//
//  Created by Emre Koç on 11.01.2024.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel
    @State private var numberOfQuestions: Int
    @State private var difficulty: String
    @State private var category: Int
    @State private var navigateToResult = false

    init(user: User, numberOfQuestions: Int, difficulty: String, category: Int) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(user: user))
        self.numberOfQuestions = numberOfQuestions
        self.difficulty = difficulty
        self.category = category
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
                    .onAppear {
                        viewModel
                            .loadQuestions(
                                numberOfQuestions: numberOfQuestions,
                                difficulty: difficulty,
                                category: category)
                    }
            } else {
                if navigateToResult {
                    QuizResultView(quizId: viewModel.quizId, user: viewModel.user)
                } else {
                    List(viewModel.questionList, id: \.self) { question in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(question.question)
                                .fontWeight(.bold)
                            ForEach(viewModel.questionsAndAnswers[question.question] ?? [], id: \.self) { answer in
                                Text(answer)
                                    .onTapGesture {
                                        viewModel.selectedAnswers[question.question] = answer

                                    }
                                    .background(
                                                viewModel.selectedAnswers[question.question] == answer ?
                                                Color.blue.opacity(0.5) : Color.clear
                                            )
                                            .cornerRadius(5)
                            }
                        }
                        .listRowBackground(Color.teal.opacity(0.1))

                    }

                    Button("Submit") {
                        viewModel.submitQuiz()
                        navigateToResult = true
                    }
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .navigationTitle("QUIZ")
    }
}

#Preview {
    QuizView(user: User(uid: "", username: "", profileImageUrl: "", quizzes: [:], points: 0),
             numberOfQuestions: 10, difficulty: "easy", category: 21)
}
