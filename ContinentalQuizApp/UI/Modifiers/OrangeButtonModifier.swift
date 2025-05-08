//
//  OrangeButtonModifier.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 08/05/25.
//

import Foundation
import SwiftUI

struct OrangeButtonModifier: ViewModifier {
    var backgroundColor: Color = Colors.orange_FF7043
    var textColor: Color = .white
    var cornerRadius = 5.0
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(textColor)
            .background(backgroundColor)
            .multilineTextAlignment(.center)
            .cornerRadius(cornerRadius)
    }
    
}
