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
    
    var body: some View {
        VStack(spacing: 0) {
            TopOrangeView()
            HeaderView()
            TimerInputView(onSave: startTimer)
            CountDownTimer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .onAppear {
            
        }
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
    
    private func HeaderView() -> some View {
        VStack(spacing: 0) {
            HStack {
                TimerView()
                Title()
            }
            HorizontalDividerView()
        }
        .padding(.top, 15)
        .padding(.horizontal, 5)
    }
    
    private func Title() -> some View {
        Text("FLAGS CHALLENGE")
            .foregroundStyle(Colors.orange_FF7043)
            .font(AppFont.interSemibold18.returnFont())
            .shadow(color: .gray, radius: 2, x: 0, y: 4)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func startTimer(seconds: Int) {
        remainingTime = seconds
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let time = remainingTime, time > 0 {
                remainingTime = time - 1
            } else {
                timer?.invalidate()
                timer = nil
            }
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
                    Text("Will Start in")
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
                TimeInputField(text: $hourTens)
                TimeInputField(text: $hourUnits)
            }
        }
    }
    
    private func MinuteField() -> some View {
        VStack(spacing: 3) {
            Text("Minute")
                .font(.system(size: 13, weight: .regular))
            HStack(spacing: 5) {
                TimeInputField(text: $minuteTens)
                TimeInputField(text: $minuteUnits)
            }
        }
    }
    
    private func SecondField() -> some View {
        VStack(spacing: 3) {
            Text("Second")
                .font(.system(size: 13, weight: .regular))
            HStack(spacing: 5) {
                TimeInputField(text: $secondTens)
                TimeInputField(text: $secondUnits)
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

#Preview {
    HomeView()
}
