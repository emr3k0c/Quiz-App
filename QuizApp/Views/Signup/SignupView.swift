//
//  SignupView.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI
import PhotosUI

struct SignupView: View {

    @StateObject private var viewModel = SignupViewModel()
    @State var photosPickerItem: PhotosPickerItem?

    var body: some View {
        if viewModel.successfullyRegisered {
            LoginView()
        } else {
            VStack {
                Text("QUIZZY")
                    .font(.custom("Arial", fixedSize: 70))
                    .fontWeight(.heavy)
                    .shadow(color: .gray, radius: 1, x: 0, y: 10)
                    .rotationEffect(.degrees(-5))
                    .foregroundColor(Color.indigo)

                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Image(uiImage: viewModel.profilePhoto)
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 100, height: 100)
                        .clipShape(.circle)
                        .padding(.bottom, -30)
                }

                Text("Tap the avatar to upload a photo.")
                    .foregroundColor(.indigo)
                .padding(Spacing.spacing_5)
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                ButtonDS(buttonTitle: "Signup") {
                    viewModel.register()

                }
            }
            .onChange(of: photosPickerItem) {_, _ in
                Task {
                    if let photosPickerItem,
                       let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            viewModel.profilePhoto = image
                        }
                        self.photosPickerItem = nil
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mint.opacity(0.3))
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(""),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"),
                    action: {
                    if viewModel.alertMessage == "User registered successfully." {
                        viewModel.successfullyRegisered = true
                    }
                }))
            }
        }
    }

}

#Preview {
    SignupView()
}
