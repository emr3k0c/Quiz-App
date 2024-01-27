//
//  Top10ViewModel.swift
//  QuizApp
//
//  Created by Emre Koç on 18.01.2024.
//

import Foundation
import FirebaseFirestore

class Top10ViewModel: ObservableObject {
    @Published var user: User
    @Published var userPoints: [String: Int] = [:]

    init(user: User) {
        self.user = user
        fetchData()
    }

    func fetchData() {
        let database = Firestore.firestore()
        database.collection("users").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents found: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var newUserPoints: [String: Int] = [:]

            for document in documents {
                if let points = document.data()["points"] as? Int {
                    if let username = document.data()["username"] as? String {
                        newUserPoints[username] = points
                    }
                }
            }

            DispatchQueue.main.async {
                self.userPoints = newUserPoints
                print(self.userPoints)
            }
        }
    }
}
