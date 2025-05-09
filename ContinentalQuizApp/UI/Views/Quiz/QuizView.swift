//
//  QuizView.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import SwiftUI

struct QuizView: View {
    @EnvironmentObject var viewModel: QuestionViewModel
    @Environment(\.scenePhase) var scenePhase
    @State private var currentQuestionIndex = UserDefaults.standard.integer(forKey: "currentQuestionIndex")
    @State private var selectedCountryId: Int? = nil
    @State private var isAnswered = false
    @State private var timer: Timer? = nil
    @State private var countdown = UserDefaults.standard.integer(forKey: "countdown") == 0 ? 30 : UserDefaults.standard.integer(forKey: "countdown")
    @State private var isTimeUp = false
    @State private var isGameOver = false
    @State private var showScore = false
    @State private var score = UserDefaults.standard.integer(forKey: "score")

    var body: some View {
        VStack(spacing: 20) {
            if isGameOver {
                ResultView()
            } else {
                QuestionHeaderView()
                QuizOptionsView()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            startTimer()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                saveQuizState()
            }
        }
    }
    
    private func saveQuizState() {
        UserDefaults.standard.set(currentQuestionIndex, forKey: "currentQuestionIndex")
        UserDefaults.standard.set(countdown, forKey: "countdown")
        UserDefaults.standard.set(score, forKey: "score")
    }

    private func resetQuizState() {
        UserDefaults.standard.removeObject(forKey: "currentQuestionIndex")
        UserDefaults.standard.removeObject(forKey: "countdown")
        UserDefaults.standard.removeObject(forKey: "score")
    }
    
    private func getTextColor(for countryId: Int, correctId: Int) -> Color {
        if isAnswered {
            if countryId == correctId {
                return .black
            } else if countryId == selectedCountryId {
                return .white
            }
        }
        return .black
    }

    private func buttonBackground(for countryId: Int, correctId: Int) -> Color {
        if isTimeUp || isAnswered {
            if countryId == selectedCountryId {
                if countryId == correctId {
                    return Color.white
                } else {
                    return Color.orange
                }
            }
        }
        return Color.white
    }

    private func returnOptionBorderColor(for countryId: Int, correctId: Int) -> Color {
        if isTimeUp || isAnswered {
            if countryId == correctId {
                return Color.green
            } else if countryId == selectedCountryId {
                return Color.orange
            }
        }
        return Color.black
    }
    
    @ViewBuilder
    private func QuizOptionsView() -> some View {
        if !viewModel.questions.isEmpty {
            let question = viewModel.questions[currentQuestionIndex]
            let countries = question.countries
            let midIndex = countries.count / 2
            let firstColumn = Array(countries.prefix(midIndex + countries.count % 2))
            let secondColumn = Array(countries.suffix(from: midIndex + countries.count % 2))

            HStack(alignment: .top) {
                FlagImageView(question.countryCode)
                Spacer()
                HStack(alignment: .top, spacing: 20) {
                    VStack(spacing: 10) {
                        ForEach(firstColumn, id: \.id) { country in
                            countryButton(for: country, correctId: question.answerID)
                        }
                    }

                    VStack(spacing: 10) {
                        ForEach(secondColumn, id: \.id) { country in
                            countryButton(for: country, correctId: question.answerID)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 25)

            if isTimeUp {
                Text("Time's Up!")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        } else {
            Text("Loading questions...")
        }
    }

    @ViewBuilder
    private func countryButton(for country: Country, correctId: Int) -> some View {
        VStack(spacing: 5) {
            Button(action: {
                guard !isAnswered else { return }
                selectedCountryId = country.id
                isAnswered = true
                stopTimer()
                if country.id == correctId {
                    score += 1
                }
                evaluateAnswer()
            }) {
                Text(country.countryName)
                    .padding(.horizontal, 10)
                    .frame(width: 120, height: 25)
                    .background(buttonBackground(for: country.id, correctId: correctId))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(getTextColor(for: country.id, correctId: correctId))
                    .minimumScaleFactor(0.8)
                    .cornerRadius(2)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(returnOptionBorderColor(for: country.id, correctId: correctId), lineWidth: 1)
            )
            
            Text(resultText(for: country.id, correctId: correctId))
                .font(.system(size: 6, weight: .regular))
                .foregroundColor(resultColor(for: country.id, correctId: correctId))
                .frame(height: 8)
        }
    }

    private func resultText(for id: Int, correctId: Int) -> String {
        guard isAnswered else { return "" }
        if selectedCountryId == id {
            return id == correctId ? "CORRECT" : "WRONG"
        } else if id == correctId {
            return "CORRECT"
        }
        return ""
    }

    private func resultColor(for id: Int, correctId: Int) -> Color {
        guard isAnswered else { return .clear }
        if selectedCountryId == id {
            return id == correctId ? Colors.green_01C414 : Colors.red_FF0000
        } else if id == correctId {
            return Colors.green_01C414
        }
        return .clear
    }
    
    @ViewBuilder
    private func FlagImageView(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 60)
            .shadow(radius: 2)
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
        resetQuizState()
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
        VStack {
            HeaderWithTimer(time: $countdown)
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
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

//#Preview {
//    QuizView()
//}
