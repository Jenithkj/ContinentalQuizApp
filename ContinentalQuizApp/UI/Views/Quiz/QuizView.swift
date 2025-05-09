//
//  QuizView.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import SwiftUI

struct QuizView: View {
    @StateObject var viewModel = QuestionViewModel()
    @State private var currentQuestionIndex = 0
    @State private var selectedCountryId: Int? = nil
    @State private var isAnswered = false
    @State private var timer: Timer? = nil
    @State private var countdown = 30
    @State private var isTimeUp = false

    @State private var isGameOver = false
    @State private var showScore = false
    @State private var score = 0

    var body: some View {
        VStack(spacing: 20) {
            if isGameOver {
                ResultView()
            } else {
                QuestionHeaderView()
                if !viewModel.questions.isEmpty {
                    let question = viewModel.questions[currentQuestionIndex]
                    Image(question.countryCode)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 55)
                        .shadow(radius: 2)

                    Text("Time Left: \(countdown) seconds")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    let columns = [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ]

                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(question.countries, id: \.id) { country in
                            VStack(spacing: 5) {
                                Button(action: {
                                    guard !isAnswered else { return }
                                    selectedCountryId = country.id
                                    isAnswered = true
                                    stopTimer()
                                    if country.id == question.answerID {
                                        score += 1
                                    }
                                    evaluateAnswer()
                                }) {
                                    Text(country.countryName)
                                        .frame(height: 25)
                                        .frame(maxWidth: .infinity)
                                        .background(buttonBackground(for: country.id, correctId: question.answerID))
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.black)
                                        .minimumScaleFactor(0.8)
                                        .cornerRadius(4)
                                }

                                if isAnswered {
                                    if selectedCountryId == country.id {
                                        if country.id == question.answerID {
                                            Text("Correct").foregroundColor(.green)
                                        } else {
                                            Text("Wrong").foregroundColor(.red)
                                        }
                                    } else if country.id == question.answerID {
                                        Text("Correct").foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    }

                    if isTimeUp {
                        Text("Time's Up!")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                } else {
                    Text("Loading questions...")
                }
            }

            Spacer()
        }
        .onAppear {
            startTimer()
        }
    }

    private func buttonBackground(for countryId: Int, correctId: Int) -> Color {
        if isTimeUp || isAnswered {
            if countryId == correctId {
                return Color.green.opacity(0.3)
            } else if countryId == selectedCountryId {
                return Color.red.opacity(0.3)
            }
        }
        return Color.blue.opacity(0.2)
    }

    private func startTimer() {
        countdown = 30
        isAnswered = false
        isTimeUp = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                timeUp()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func timeUp() {
        isTimeUp = true
        stopTimer()

        if selectedCountryId == nil {
            selectedCountryId = viewModel.questions[currentQuestionIndex].answerID
        }

        moveToNextQuestionAfterDelay()
    }

    private func evaluateAnswer() {
        moveToNextQuestionAfterDelay()
    }

    private func moveToNextQuestionAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if currentQuestionIndex < viewModel.questions.count - 1 {
                currentQuestionIndex += 1
                resetQuestion()
            } else {
                showGameOver()
            }
        }
    }

    private func showGameOver() {
        isGameOver = true
        stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showScore = true
        }
    }

    private func resetQuestion() {
        selectedCountryId = nil
        isAnswered = false
        isTimeUp = false
        startTimer()
    }
    
    private func ResultView() -> some View {
        VStack {
            if showScore {
                HStack {
                    Text("SCORE:")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.orangeFF7043)
                    Text("\(score)/\(viewModel.questions.count)")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(Colors.gray_484848)
                }

            } else {
                Text("GAME OVER")
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundColor(Colors.gray_484848)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 55)
        .background(Colors.gray_D9D9D9)
    }
    
    private func QuestionHeaderView() -> some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 44, height: 40)
                    .cornerRadius(5, corners: [.topRight, .bottomRight])
                Text("\(currentQuestionIndex + 1)")
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(Colors.orange_FF7043)
                    .cornerRadius(15)
            }
            Spacer()
            Text("GUESS THE COUNTRY FROM THE FLAG ?")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct QuestionView: View {
    let question: Question

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

        }
        .padding()
    }
}


//#Preview {
//    QuizView()
//}
