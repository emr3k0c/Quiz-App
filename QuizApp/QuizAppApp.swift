//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI
import Firebase

@main
struct QuizAppApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.colorScheme, .light)
        }
    }
}
