//
//  PastQuizzes.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI

struct PastQuizzesView: View {

    @StateObject private var viewModel: PastQuizzesViewModel

    init(user: User) {
        _viewModel = StateObject(wrappedValue: PastQuizzesViewModel(user: user))
    }
    var body: some View {

        VStack {
            let keysArray = Array(viewModel.user.quizzes.keys)
            List(keysArray, id: \.self) {key in NavigationLink {
                QuizResultView(quizId: key, user: viewModel.user)
                    } label: {
                        HStack {
                            SubtitleText(text: "Quiz \(keysArray.firstIndex(of: key)! + 1)")
                            Spacer()
                            SubtitleText(text: viewModel.user.quizzes[key]?.score ?? "")
                        }
                    }
                    .listRowBackground(Color.purple.opacity(0.2))

            }
            .scrollContentBackground(.hidden)

            Spacer()
        }
        .background(Color.teal.opacity(0.15))
        .navigationTitle("PAST QUIZZES")
    }
}

#Preview { PastQuizzesView(user: User(
    uid: "dsfsd",
    username: "emre",
    profileImageUrl: "https://via.placeholder.com/150",
    quizzes: [:],
    points: 24))
}
