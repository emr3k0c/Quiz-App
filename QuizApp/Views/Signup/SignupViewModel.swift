//
//  SignupViewModel.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI
import Firebase
import FirebaseStorage

class SignupViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var profilePhoto: UIImage = UIImage(systemName: "person.crop.circle")!
    @Published var successfullyRegisered = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                print(self.showAlert)
            } else if let user = result?.user {
                let uid = user.uid
                let newUser = User(uid: uid, username: self.username, profileImageUrl: "", quizzes: [:], points: 0)

                self.addUserToFirestore(user: newUser, profileImage: self.profilePhoto) { success in
                    if success {
                        self.alertMessage = "User registered successfully."
                        self.showAlert = true
                    } else {
                        self.alertMessage = "Failed to register user."
                        self.showAlert = true
                        print(self.showAlert)
                    }
                }
            }
        }
    }

    func addUserToFirestore(user: User, profileImage: UIImage, completion: @escaping (Bool) -> Void) {
        uploadProfileImage(image: profileImage) { imageUrl in
            if let imageUrl = imageUrl {
                var updatedUser = user
                updatedUser.profileImageUrl = imageUrl

                let database = Firestore.firestore()
                let userRef = database.collection("users").document(user.uid)

                userRef.setData([
                    "username": updatedUser.username,
                    "profileImageUrl": updatedUser.profileImageUrl,
                    "quizzes": updatedUser.quizzes,
                    "points": updatedUser.points
                ]) { error in
                    if let error = error {
                        print("Error adding user to Firestore: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("User added to Firestore successfully!")
                        completion(true)
                    }
                }
            } else {
                print("Failed to upload the profile image.")
                completion(false)
            }
        }
    }

    func uploadProfileImage(image: UIImage, completion: @escaping (String?) -> Void) {
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
