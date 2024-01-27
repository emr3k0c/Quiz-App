//
//  HomeViewModel.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class HomeViewModel: ObservableObject {
    @Published var uid: String
    @Published var user = User(uid: "", username: "", profileImageUrl: "", quizzes: [:], points: 0)
    @Published var numberOfQuestions: Double = 10.0
    @Published var difficulties = ["Easy", "Medium", "Hard"]
    @Published var selectedDifficulty = "Easy"
    @Published var categoryDict = ["General": 9, "Sports": 21, "History": 23, "Politics": 24, "Animals": 27]
    @Published var categoryNames = ["General", "Sports", "History", "Politics", "Animals"]
    @Published var selectedCategory = "General"
    @Published var isLoaded = false

    init(uid: String) {
        self.uid = uid
        fetchUserData()
    }

    func fetchUserData() {
        let database = Firestore.firestore()
        let userRef = database.collection("users").document(uid)

        userRef.getDocument { [weak self] document, error in
            guard let self = self, let document = document, document.exists else {
                print("Error fetching user data: \(error?.localizedDescription ?? "No document found")")
                return
            }

            self.user.uid = document.documentID
            self.user.username = document.get("username") as! String
            self.user.points = document.get("points") as! Int
            self.user.profileImageUrl = document.get("profileImageUrl") as! String
            self.isLoaded = true
            if let quizzesData = document.get("quizzes") as? [String: [String: Any]] {
                var decodedQuizzes = [String: Quiz]()
                for (quizId, quizData) in quizzesData {
                    if let quiz = self.decodeQuiz(from: quizData) {
                        decodedQuizzes[quizId] = quiz
                    } else {
                        print("Error decoding quiz for quiz ID: \(quizId)")
                    }
                }
                DispatchQueue.main.async {
                    self.user.quizzes = decodedQuizzes
                }
            }
        }
    }

    private func decodeQuestion(from data: [String: Any]) -> Question? {
        guard let type = data["type"] as? String,
              let difficulty = data["difficulty"] as? String,
              let category = data["category"] as? String,
              let question = data["question"] as? String,
              let correctAnswer = data["correct_answer"] as? String,
              let incorrectAnswers = data["incorrect_answers"] as? [String] else {
            return nil
        }

        return Question(type: type,
                        difficulty: difficulty,
                        category: category,
                        question: question,
                        correct_answer: correctAnswer,
                        incorrect_answers: incorrectAnswers)
    }

    private func decodeQuiz(from data: [String: Any]) -> Quiz? {
        guard let score = data["score"] as? String,
              let questionsData = data["questions"] as? [[String: Any]],
              let selectedAnswersData = data["selectedAnswers"] as? [String: String] else {
            return nil
        }

        let questions = questionsData.compactMap { decodeQuestion(from: $0) }
        return Quiz(score: score, questions: questions, selectedAnswers: selectedAnswersData)
    }

    func updateProfileImage(image: UIImage, completion: @escaping (String?) -> Void) {
        self.isLoaded = false
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profileImagesRef = storageRef.child("profile_images")
        let imageFilename = "\(UUID().uuidString).jpg"

        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let imageRef = profileImagesRef.child(imageFilename)

            imageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading profile image: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                            completion(nil)
                        } else if let downloadURL = url {
                            let imageUrl = downloadURL.absoluteString
                            let database = Firestore.firestore()
                            let userRef = database.collection("users").document(self.user.uid)
                            userRef.updateData(["profileImageUrl": imageUrl]) { error in
                                if let error = error {
                                    print("Error updating profile image URL: \(error.localizedDescription)")
                                    completion(nil)
                                } else {
                                    DispatchQueue.main.async {
                                        self.user.profileImageUrl = imageUrl
                                        self.isLoaded = true
                                    }
                                }
                            }
                            completion(imageUrl)
                        }
                    }
                }
            }
        } else {
            completion(nil)
        }
    }

}
