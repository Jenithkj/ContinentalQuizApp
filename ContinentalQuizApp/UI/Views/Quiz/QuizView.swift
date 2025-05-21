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
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                VStack {
                    QuestionHeaderView()
                    QuizOptionsView()
                    HeaderWithTimer(time: $countdown)
                }
                .padding(.top)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(maxHeight: .infinity)
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

            VStack(spacing: 20) {
                FlagImageView(question.countryCode)
                    .padding(.bottom, 20)

                ForEach(countries, id: \.id) { country in
                    countryButton(for: country, correctId: question.answerID)
                }

                if isTimeUp {
                    Text("Time's Up!")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 25)
        } else {
            Text("Loading questions...")
        }
    }


    @ViewBuilder
    private func countryButton(for country: Country, correctId: Int) -> some View {
        VStack(spacing: 6) {
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
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(getTextColor(for: country.id, correctId: correctId))
                    .background(buttonBackground(for: country.id, correctId: correctId))
                    .cornerRadius(12)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(returnOptionBorderColor(for: country.id, correctId: correctId), lineWidth: 1.5)
            )

            Text(resultText(for: country.id, correctId: correctId))
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(resultColor(for: country.id, correctId: correctId))
                .frame(height: 12)
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
            return id == correctId ? .yellow : Colors.red_FF0000
        } else if id == correctId {
            return .yellow
        }
        return .clear
    }
    
    @ViewBuilder
    private func FlagImageView(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 95)
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
        VStack(spacing: 25) {
            if !showScore {
                VStack(spacing: 12) {
                    Text("Your Score")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .textCase(.uppercase)

                    Text("\(score)/\(viewModel.questions.count)")
                        .font(.system(size: 60, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 3)

                    if score >= viewModel.questions.count / 2 {
                        Text("Well done! 🎉")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.green)
                    } else {
                        Text("Try again! 💪")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.yellow)
                    }
                }
            } else {
                Text("Quiz Over")
                    .font(.system(size: 45, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .padding(.horizontal, 20)
        .background(
            LinearGradient(
                colors: [Colors.orange_FF7043, Colors.gray_484848],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
        )
        .padding(.horizontal, 20)
    }



    
    private func QuestionHeaderView() -> some View {
        VStack {
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
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

//#Preview {
//    QuizView()
//}
