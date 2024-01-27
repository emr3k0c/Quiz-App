//
//  Top10View.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI

struct Top10View: View {

    @StateObject private var viewModel: Top10ViewModel
    init(user: User) {
        _viewModel = StateObject(wrappedValue: Top10ViewModel(user: user))
    }

    var body: some View {
        VStack {
            var points = sortedPoints()
            List {
                ForEach(Array(points.enumerated()), id: \.element.self) { index, point in
                    HStack {
                        Text("\(index + 1). \(point.username)")
                            .padding()
                        Spacer()
                        Text(String(point.points))
                    }
                }
                .listRowBackground(Color.purple.opacity(0.2))
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("TOP 10 PLAYERS")
        }
        .background(Color.teal.opacity(0.15))

    }

    func sortedPoints() -> [UserPoints] {
        let userPointsArray = viewModel.userPoints.map { UserPoints(username: $0.key, points: $0.value) }
        let sortedUserPointsArray = userPointsArray.sorted { $0.points > $1.points }

        let upperBound = min(sortedUserPointsArray.count, 10)
        return Array(sortedUserPointsArray.prefix(upTo: upperBound))
    }

}

struct UserPoints: Hashable {
    let username: String
    let points: Int
}

#Preview {
    Top10View(user: User(uid: "432", username: "", profileImageUrl: "", quizzes: [:], points: 5))
}
