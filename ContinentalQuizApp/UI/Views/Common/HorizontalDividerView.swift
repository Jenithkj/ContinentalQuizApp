//
//  HorizontalDividerView.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 07/05/25.
//

import Foundation
import SwiftUI

struct HorizontalDividerView: View {
    var color = Color.gray
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}
