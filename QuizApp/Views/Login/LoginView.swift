//
//  ContentView.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel = LoginViewModel()
    @State private var navigateToSignup = false
    @State private var navigateToHome = false

    var body: some View {

        if navigateToHome {
            HomeView(uid: viewModel.uid)
        } else {
            NavigationStack {
                VStack {
                    Text("QUIZZY")
                        .font(.custom("Arial", fixedSize: 70))
                        .fontWeight(.heavy)
                        .shadow(color: .gray, radius: 1, x: 0, y: 10)
                        .rotationEffect(.degrees(-5))
                        .foregroundColor(Color.indigo)
                        .padding(.top, 105)

                    Spacer()

                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)

                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)

                    ButtonDS(buttonTitle: "Login") {
                        viewModel.login { uid in
                            if let uid = uid {
                                viewModel.uid = uid
                                UserDefaults.standard.setValue(viewModel.uid, forKey: "userUid")

                            } else {
                                print("Login failed.")
                            }
                        }
                    }

                    Text("Don't have an account yet? Sign up")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            navigateToSignup = true
                        }
                    Spacer()

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mint.opacity(0.3))
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(""),
                          message: Text(viewModel.alertMessage),
                          dismissButton: .default(Text("OK"), action: {
                        if viewModel.alertMessage == "You have succesfully logged in." {
                            navigateToHome = true
                        }
                    }))
                }

                NavigationLink(destination: SignupView(), isActive: $navigateToSignup) {
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("LOG IN")
            .onAppear {
                if let userUid = UserDefaults.standard.string(forKey: "userUid") {
                    viewModel.uid = userUid
                    navigateToHome = true
                }
            }
        }

    }

}

#Preview {
    LoginView()
}
