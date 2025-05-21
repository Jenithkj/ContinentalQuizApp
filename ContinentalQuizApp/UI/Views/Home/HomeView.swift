//
//  HomeView.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 06/05/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var remainingTime: Int? = nil
    @State private var timer: Timer?
    @State private var screenFlow: ScreenFlow = .scheduleQuiz
    @StateObject var viewModel = QuestionViewModel()
    @State private var currentQuestionIndex: Int = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .purple, .blue], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if screenFlow == .scheduleQuiz {
                    TimerInputView(onSave: startTimer)
                } else if screenFlow == .countdownQuiz {
                    CountDownTimer()
                } else if screenFlow == .activeQuiz {
                    QuizView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
    

    
    private func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func startTimer(seconds: Int) {
        remainingTime = seconds
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard let time = remainingTime else { return }
            if time == 0 {
                screenFlow = .activeQuiz
                timer?.invalidate()
                timer = nil
                return
            } else {
                screenFlow = .countdownQuiz
            }
            remainingTime = time - 1
        }
    }
    
    @ViewBuilder
    private func CountDownTimer() -> some View {
        if let time = remainingTime {
            ZStack {
                // Glowing circular aura
                Circle()
                    .fill(Color.pink.opacity(0.1))
                    .frame(width: 240, height: 240)
                    .blur(radius: 40)
                    .scaleEffect(1.1)
                    .shadow(color: .neonPink.opacity(0.7), radius: 30)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: time)
                
                VStack(spacing: 14) {
                    Text("⚡ CHALLENGE ⚡")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.neonBlue)
                        .shadow(color: .neonBlue.opacity(0.9), radius: 12)
                    
                    Text("Will start in")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    
                    Text(formatTime(time))
                        .font(.system(size: 46, weight: .bold, design: .monospaced))
                        .foregroundColor(.neonPink)
                        .shadow(color: .neonPink, radius: 18)
                }
                .padding(35)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.black.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(
                                    LinearGradient(colors: [.neonPink, .neonBlue], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 2.5
                                )
                        )
                        .shadow(color: .neonBlue.opacity(0.5), radius: 10)
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 40)
        }
    }
}

extension Color {
    static let neonPink = Color(red: 1.0, green: 0.2, blue: 0.6)
    static let neonBlue = Color(red: 0.1, green: 0.9, blue: 1.0)
}



struct TimerInputView: View {
    @State private var hourTens = ""
    @State private var hourUnits = ""
    @State private var minuteTens = ""
    @State private var minuteUnits = ""
    @State private var secondTens = ""
    @State private var secondUnits = ""
    var onSave: (Int) -> Void
    @FocusState private var focusedField: TimeField?

    var body: some View {
        VStack(spacing: 40) {
            Text("⏱ SCHEDULE")
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(.mint)
                .shadow(color: .mint, radius: 10)

            HStack(spacing: 32) {
                timeInputGroup(title: "Hour", digits: [$hourTens, $hourUnits], fields: [.hourTens, .hourUnits])
                timeInputGroup(title: "Minute", digits: [$minuteTens, $minuteUnits], fields: [.minuteTens, .minuteUnits])
                timeInputGroup(title: "Second", digits: [$secondTens, $secondUnits], fields: [.secondTens, .secondUnits])
            }

            Button(action: {
                let hours = (Int(hourTens) ?? 0) * 10 + (Int(hourUnits) ?? 0)
                let minutes = (Int(minuteTens) ?? 0) * 10 + (Int(minuteUnits) ?? 0)
                let seconds = (Int(secondTens) ?? 0) * 10 + (Int(secondUnits) ?? 0)
                let totalSeconds = hours * 3600 + minutes * 60 + seconds
                onSave(totalSeconds)
            }) {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .frame(width: 120)
                    .background(LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .purple, radius: 10)
                    .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(.black.opacity(0.6))
        .cornerRadius(25)
        .shadow(color: .purple.opacity(0.5), radius: 20)
    }

    private func timeInputGroup(title: String, digits: [Binding<String>], fields: [TimeField]) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
            HStack(spacing: 15) {
                ForEach(0..<2, id: \.self) { index in
                    TimeInputField(text: digits[index], field: fields[index], focusedField: $focusedField)
                        .frame(width: 30, height: 45)
                        .padding(.horizontal, 5)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: fields[index])
                }
            }
        }
    }
}


enum ScreenFlow {
    case scheduleQuiz
    case countdownQuiz
    case activeQuiz
}

#Preview {
    HomeView()
}

//HeaderWithTimer(time: Binding(
//    get: { remainingTime ?? 0 },
//    set: { remainingTime = $0 }
//))
