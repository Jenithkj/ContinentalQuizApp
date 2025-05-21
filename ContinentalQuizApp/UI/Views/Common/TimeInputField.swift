//
//  TimeInputField.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import Foundation
import SwiftUI

struct TimeInputField: View {
    @Binding var text: String
    var field: TimeField
    @FocusState.Binding var focusedField: TimeField?

    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(AppFont.interSemibold28.returnFont())
            .frame(width: 50, height: 50)
            .background(Color(.systemGray4))
            .cornerRadius(10)
            .foregroundColor(.black)
            .focused($focusedField, equals: field)
            .onChange(of: text) { newValue in
                if newValue.count > 1 || !newValue.allSatisfy(\.isNumber) {
                    text = String(newValue.prefix(1).filter { $0.isNumber })
                }
                if text.count == 1 {
                    focusedField = moveToNextField()
                }
            }
    }

    private func moveToNextField() -> TimeField? {
        switch field {
        case .hourTens:
            return .hourUnits
        case .hourUnits:
            return .minuteTens
        case .minuteTens:
            return .minuteUnits
        case .minuteUnits:
            return .secondTens
        case .secondTens:
            return .secondUnits
        default:
            return nil
        }
    }
}

enum TimeField: Hashable {
    case hourTens, hourUnits, minuteTens, minuteUnits, secondTens, secondUnits
}
