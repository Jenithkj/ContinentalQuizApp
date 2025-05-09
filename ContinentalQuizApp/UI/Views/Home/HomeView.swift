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
        VStack(spacing: 0) {
            TopOrangeView()
            if screenFlow == .scheduleQuiz {
                HeaderWithTimer(time: Binding(
                    get: { remainingTime ?? 0 },
                    set: { remainingTime = $0 }
                ))
                TimerInputView(onSave: startTimer)
            } else if screenFlow == .countdownQuiz {
                CountDownTimer()
            } else if screenFlow == .activeQuiz {
                QuizView()
                    .environmentObject(viewModel)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }
    
    private func TimerView() -> some View {
        VStack {
            Text(formatTime(remainingTime ?? 0))
                .foregroundStyle(.white)
                .padding(20)
        }
        .background(.black)
        .cornerRadius(10, corners: [.topLeft, .topRight, .bottomRight])
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func TopOrangeView() -> some View {
        Rectangle()
            .fill(Colors.orange_FF7043)
            .frame(height: 100)
    }
    
    private func startTimer(seconds: Int) {
        remainingTime = seconds
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard let time = remainingTime else { return }
            if time > 1 && time <= 20 {
                screenFlow = .countdownQuiz
            } else if time == 0 {
                screenFlow = .activeQuiz
                timer?.invalidate()
                timer = nil
                return
            }
            remainingTime = time - 1
        }
    }

    @ViewBuilder
    private func CountDownTimer() -> some View {
        if let time = remainingTime, (1...20).contains(time) {
            VStack {
                Text("CHALLENGE")
                    .font(AppFont.interSemibold18.returnFont())
                    .foregroundStyle(.black)
                HStack {
                    Text("WILL START IN")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("00:\(String(format: "%02d", time))")
                        .foregroundStyle(Colors.gray_787878)
                        .font(AppFont.interSemibold28.returnFont())
                }
            }
        }
    }
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
        VStack(spacing: 0) {
            Schedule()
            HStack(spacing: 20) {
                HourField()
                MinuteField()
                SecondField()
            }
            .padding(.top, 15)
            SaveButton()
        }
        .padding(.top, 10)
    }
    
    private func Schedule() -> some View {
        Text("SCHEDULE")
            .font(.system(size: 25, weight: .bold))
    }
    
    private func HourField() -> some View {
        VStack(spacing: 3) {
            Text("Hour")
                .font(.system(size: 13, weight: .regular))
            HStack(spacing: 5) {
                TimeInputField(text: $hourTens, field: .hourTens, focusedField: $focusedField)
                TimeInputField(text: $hourUnits, field: .hourUnits, focusedField: $focusedField)
            }
        }
    }

    private func MinuteField() -> some View {
        VStack(spacing: 3) {
            Text("Minute")
                .font(.system(size: 13, weight: .regular))
            HStack(spacing: 5) {
                TimeInputField(text: $minuteTens, field: .minuteTens, focusedField: $focusedField)
                TimeInputField(text: $minuteUnits, field: .minuteUnits, focusedField: $focusedField)
            }
        }
    }
    
    private func SecondField() -> some View {
        VStack(spacing: 3) {
            Text("Second")
                .font(.system(size: 13, weight: .regular))
            HStack(spacing: 5) {
                TimeInputField(text: $secondTens, field: .secondTens, focusedField: $focusedField)
                TimeInputField(text: $secondUnits, field: .secondUnits, focusedField: $focusedField)
            }
        }
    }
    
    private func SaveButton() -> some View {
        CustomButton(action: {
            let hours = (Int(hourTens) ?? 0) * 10 + (Int(hourUnits) ?? 0)
            let minutes = (Int(minuteTens) ?? 0) * 10 + (Int(minuteUnits) ?? 0)
            let seconds = (Int(secondTens) ?? 0) * 10 + (Int(secondUnits) ?? 0)
            let totalSeconds = hours * 3600 + minutes * 60 + seconds
            onSave(totalSeconds)
        }, title: "Save")
        .modifier(OrangeButtonModifier())
        .frame(width: 100, height: 35)
        .padding(.top, 20)
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
