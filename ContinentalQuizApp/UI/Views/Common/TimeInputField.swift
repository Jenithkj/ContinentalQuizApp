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

    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(AppFont.interSemibold28.returnFont())
            .frame(width: 50, height: 50)
            .background(Color(.systemGray4))
            .cornerRadius(10)
            .foregroundColor(.gray)
            .onChange(of: text) { newValue in
                if newValue.count > 1 || !newValue.allSatisfy(\.isNumber) {
                    text = String(newValue.prefix(1).filter { $0.isNumber })
                }
            }
    }
}
