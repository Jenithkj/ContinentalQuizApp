//
//  QuizView.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import SwiftUI

struct QuizView: View {
    @StateObject var viewModel = QuestionViewModel()

    var body: some View {
        VStack {
            
        }
    }
}



struct QuestionView: View {
    let question: Question

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("Which country matches code: \(question.country_code)?")
//                .font(.headline)
//
//            ForEach(question.countries, id: \.id) { country in
//                Button(action: {
//                    if country.id == question.answer_id {
//                        print("Correct!")
//                    } else {
//                        print("Wrong!")
//                    }
//                }) {
//                    Text(country.country_name)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue.opacity(0.2))
//                        .cornerRadius(8)
//                }
//            }
        }
        .padding()
    }
}


//#Preview {
//    QuizView()
//}
