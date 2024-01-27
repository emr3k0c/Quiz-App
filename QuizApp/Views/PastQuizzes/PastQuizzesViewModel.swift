//
//  PastQuizzesViewModel.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation

class PastQuizzesViewModel: ObservableObject {
    @Published var user: User

        init(user: User) {
            self.user = user
        }
}
