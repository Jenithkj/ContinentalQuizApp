//
//  CustomButton.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    let action: CompletionHandler
    var title: String
    var multilineTextAlignment: TextAlignment?
    var lineLimit: Int = 2
    var minimumScaleFactor = 1.0
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .minimumScaleFactor(minimumScaleFactor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(multilineTextAlignment ?? .center)
                .lineLimit(lineLimit)
        }
    }
}
