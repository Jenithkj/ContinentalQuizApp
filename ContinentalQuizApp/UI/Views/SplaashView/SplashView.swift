//
//  SplashView.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 21/05/25.
//

import Foundation
import SwiftUI

struct AnimatedWordSplashView: View {
    @Binding var isActive: Bool
    @State private var wordAnimations: [Bool]
    private let words = ["Welcome to", "Continental", "Quiz APP"]

    init(isActive: Binding<Bool>) {
        self._isActive = isActive
        _wordAnimations = State(initialValue: Array(repeating: false, count: words.count))
    }

    var body: some View {
        splashView
            .onAppear(perform: runAnimations)
    }

    private var splashView: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.85)]),
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                ForEach(words.indices, id: \.self) { wordIndex in
                    WordView(
                        word: words[wordIndex],
                        isActive: wordAnimations[wordIndex],
                        wordIndex: wordIndex
                    )
                }
            }
            .padding(.horizontal, 30)
        }
    }

    private func runAnimations() {
        for i in words.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                withAnimation {
                    wordAnimations[i] = true
                }
            }
        }
        let totalDelay = Double(words.count) * 0.5 + 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            isActive = false
        }
    }
}

struct WordView: View {
    let word: String
    let isActive: Bool
    let wordIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(word.enumerated()), id: \.offset) { (charIndex, character) in
                AnimatedCharacterView(
                    character: character,
                    isActive: isActive,
                    wordIndex: wordIndex,
                    charIndex: charIndex
                )
            }
        }
    }
}

struct AnimatedCharacterView: View {
    let character: Character
    let isActive: Bool
    let wordIndex: Int
    let charIndex: Int

    var body: some View {
        let delay = Double(wordIndex) * 0.5 + Double(charIndex) * 0.05

        Group {
            if wordIndex == 0 {
                Text(String(character))
                    .font(.system(size: 42, weight: .medium, design: .monospaced))
                    .foregroundColor(.cyan)
                    .shadow(color: Color.cyan.opacity(0.8), radius: 6)
            } else {
                Text(String(character))
                    .font(.custom("AvenirNext-Bold", size: 36))
                    .foregroundColor(color(for: wordIndex))
                    .shadow(color: color(for: wordIndex).opacity(0.6), radius: 4)
            }
        }
        .opacity(isActive ? 1 : 0)
        .scaleEffect(isActive ? 1.15 : 0.3)
        .rotation3DEffect(
            .degrees(isActive ? 0 : 90),
            axis: (x: 1, y: 0, z: 0)
        )
        .animation(.easeOut(duration: 0.6).delay(delay), value: isActive)
    }

    private func color(for wordIndex: Int) -> Color {
        switch wordIndex {
        case 1: return .pink
        case 2: return .green
        default: return .white
        }
    }
}
