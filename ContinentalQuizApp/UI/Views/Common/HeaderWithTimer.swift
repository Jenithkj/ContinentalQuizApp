//
//  HeaderWithTimer.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 09/05/25.
//

import SwiftUI

struct HeaderWithTimer: View {
    @Binding var time: Int
    
    var body: some View {
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
    
    private func TimerView() -> some View {
        VStack {
            Text(formatTime(time ?? 0))
                .foregroundStyle(.white)
                .padding(20)
        }
        .background(.black)
        .cornerRadius(10, corners: [.topLeft, .topRight, .bottomRight])
    }
    
    private func Title() -> some View {
        Text("FLAGS CHALLENGE")
            .foregroundStyle(Colors.orange_FF7043)
            .font(AppFont.interSemibold18.returnFont())
            .shadow(color: .gray, radius: 2, x: 0, y: 4)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
