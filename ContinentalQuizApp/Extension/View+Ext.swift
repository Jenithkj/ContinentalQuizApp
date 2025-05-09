//
//  View+Ext.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 07/05/25.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
