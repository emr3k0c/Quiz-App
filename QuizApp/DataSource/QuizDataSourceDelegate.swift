//
//  QuizDataSourceDelegate.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation

protocol QuizDataSourceDelegate {
    func questionListLoaded(questionList: [Question])
}
