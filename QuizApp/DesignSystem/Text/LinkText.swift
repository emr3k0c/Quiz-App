//
//  LinkText.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import SwiftUI

struct LinkText: View {

    let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .foregroundStyle(.indigo)
    }
}

#Preview {
    LinkText(text: "Test")
}
