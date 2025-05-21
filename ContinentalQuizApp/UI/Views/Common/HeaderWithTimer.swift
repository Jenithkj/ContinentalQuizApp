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
                Spacer()
                timerView
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 15)
        }
    }

    private var timerView: some View {
        Text(timeFormatted)
            .font(.system(size: 24, weight: .bold, design: .monospaced))
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.4))
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
                    .shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: -2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }

    private var timeFormatted: String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

