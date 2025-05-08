//
//  QuestionViewModel.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import Foundation
import SwiftUI

class QuestionViewModel: ObservableObject {
    @Published var questions: [Question] = []

    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        if let url = Bundle.main.url(forResource: "Questions", withExtension: "json") {
            print("JSON file found at: \(url)")
            do {
                let data = try Data(contentsOf: url)
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let questionsArray = jsonObject["questions"] as? [[String: Any]] {
                    var loadedQuestions: [Question] = []
                    for questionDict in questionsArray {
                        guard let answerID = questionDict["answer_id"] as? Int,
                              let countriesArray = questionDict["countries"] as? [[String: Any]],
                              let countryCode = questionDict["country_code"] as? String else {
                            continue
                        }
                        var countries: [Country] = []
                        for countryDict in countriesArray {
                            if let countryName = countryDict["country_name"] as? String,
                               let id = countryDict["id"] as? Int {
                                let country = Country(countryName: countryName, id: id)
                                countries.append(country)
                            }
                        }
                        let question = Question(answerID: answerID, countries: countries, countryCode: countryCode)
                        loadedQuestions.append(question)
                    }
                    self.questions = loadedQuestions
                    print("Parsed questions successfully: \(loadedQuestions.count) loaded.")
                } else {
                    print("Failed to cast JSON to expected dictionary structure.")
                }
            } catch {
                print("Error reading or parsing JSON: \(error.localizedDescription)")
            }
        } else {
            print("Failed to find JSON file in the bundle.")
        }
    }

}
