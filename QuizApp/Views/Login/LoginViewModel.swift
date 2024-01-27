//
//  LoginViewModel.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var uid = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    func login(completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                completion(nil)
            } else if let user = result?.user {
                let uid = user.uid
                self.alertMessage = "You have succesfully logged in."
                self.showAlert = true
                completion(uid)
            }
        }
    }
}
