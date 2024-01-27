//
//  User.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation

class User: ObservableObject {
    @Published var uid: String
    @Published var username: String
    @Published var profileImageUrl: String
    @Published var quizzes: [String: Quiz]
    @Published var points: Int

    init(uid: String, username: String, profileImageUrl: String, quizzes: [String: Quiz], points: Int) {
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.quizzes = quizzes
        self.points = points
    }
}
