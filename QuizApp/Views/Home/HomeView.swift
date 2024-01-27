//
//  HomeView.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State var photosPickerItem: PhotosPickerItem?
    @State private var navigateToQuiz = false
    @State private var isUserLoggedOut = false

    init(uid: String) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(uid: uid))

    }

    var body: some View {
        if isUserLoggedOut {
            LoginView()
        } else if viewModel.isLoaded == false {
            LoadingView()
                .onAppear {
                    viewModel.fetchUserData()
                }
        } else {
            NavigationStack {
                VStack {
                    HStack {
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            let url = viewModel.user.profileImageUrl
                            AsyncImage(url: URL(string: url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        TitleText(text: viewModel.user.username)
                            .padding()
                            .padding(.vertical, 20)

                        Button(action: {
                            UserDefaults.standard.removeObject(forKey: "userUid")
                            isUserLoggedOut = true
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.indigo)
                                .font(.largeTitle)
                                .padding()
                                    }
                    }

                    StepperDS(
                        value: $viewModel.numberOfQuestions,
                        minValue: 5,
                        maxValue: 20
                    )
                    .padding(.horizontal, 20)
                    Spacer()
                    SubtitleText(text: "Select the Difficulty")
                        .foregroundColor(.black.opacity(0.5))
                    Picker("Select the Difficulty", selection: $viewModel.selectedDifficulty) {
                        ForEach(viewModel.difficulties, id: \.self) {
                                        Text($0)
                                    }
                                }
                    .pickerStyle(.palette)

                    Spacer()

                    SubtitleText(text: "Select the Category")
                        .foregroundColor(.black.opacity(0.5))
                    Picker("Select the Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categoryNames, id: \.self) {
                                        Text($0)
                                    }
                                }
                    .pickerStyle(.menu)

                    Spacer()
                    ButtonDS(buttonTitle: "Generate Quiz") {
                        navigateToQuiz = true
                    }
                    HStack {
                        bottomBarView
                        Spacer()

                    }
                    .padding(20)
                }
                .onChange(of: photosPickerItem) {_, _ in
                    Task {
                        if let photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                viewModel.updateProfileImage(image: image) { imageUrl in
                                    if let imageUrl = imageUrl {
                                        print("Profile photo is succesfully updated!")
                                    }
                                }
                            }
                            self.photosPickerItem = nil
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.teal.opacity(0.15).ignoresSafeArea())
                NavigationLink(destination:
                                QuizView(
                                    user: viewModel.user,
                                    numberOfQuestions: Int(viewModel.numberOfQuestions),
                                    difficulty: viewModel.selectedDifficulty.lowercased(),
                                    category: viewModel.categoryDict[viewModel.selectedCategory]!),
                               isActive: $navigateToQuiz) {
                           EmptyView()
                       }

            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("HOME")

        }

    }

    private var bottomBarView: some View {
        HStack(spacing: .zero) {

            NavigationLink(destination: Top10View(user: viewModel.user)) {
                LinkText(text: "Top 10")
            }
            Spacer()
            NavigationLink(destination: PastQuizzesView(user: viewModel.user)) {
                LinkText(text: "Past Quizzes")
            }
        }
        .padding(Spacing.spacing_3)
    }
}

#Preview {
    HomeView(uid: "thKtSSRisHW4hJYWuNe61Y4f48f2")
}
