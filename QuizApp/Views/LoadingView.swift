//
//  LoadingView.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {
        VStack(spacing: Spacing.spacing_1) {
            ProgressView()
            Text("Loading...")
        }
    }
}

#Preview {
    LoadingView()
}
