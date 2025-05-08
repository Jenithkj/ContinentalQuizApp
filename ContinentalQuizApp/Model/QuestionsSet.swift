//
//  QuestionsSet.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import Foundation
import SwiftUI

class QuestionSet {
    let questions: [Question]

    init(questions: [Question]) {
        self.questions = questions
    }
}

class Question {
    let answerID: Int
    let countries: [Country]
    let countryCode: String

    init(answerID: Int, countries: [Country], countryCode: String) {
        self.answerID = answerID
        self.countries = countries
        self.countryCode = countryCode
    }
}

class Country {
    let countryName: String
    let id: Int

    init(countryName: String, id: Int) {
        self.countryName = countryName
        self.id = id
    }
}
