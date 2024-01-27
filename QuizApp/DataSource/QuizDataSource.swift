//
//  QuizDataSource.swift
//  QuizApp
//
//  Created by Emre Koç on 10.01.2024.
//

import Foundation

struct QuizDataSource {

    private let baseURL = "https://opentdb.com/api.php?"
    var delegate: QuizDataSourceDelegate?

    func loadQuestionList(amount: Int, category: Int, difficulty: String) {
        let session = URLSession.shared

        if let url = URL(string:
                            "\(baseURL)amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=multiple") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, _, _ in
                guard let data else { return }
                let decoder = JSONDecoder()
                print(data)
                do {
                    let responseObject = try decoder.decode(ResponseObject.self, from: data)
                    let decodedQuestions = responseObject.results.map { $0.decodedHTMLString() }
                    DispatchQueue.main.async {
                        delegate?.questionListLoaded(questionList: decodedQuestions)
                    }
                } catch {
                    print(error)
                }
            }
            dataTask.resume()
        }
    }

    }

struct ResponseObject: Decodable {
    let response_code: Int
    let results: [Question]
}
