//
//  FontUtils.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 07/05/25.
//

import Foundation
import SwiftUI

enum AppFont {
    case interSemibold18
    case interSemibold24
    case interSemibold28
    
    func returnFont() -> Font {
        switch self {
        case .interSemibold18:
            return Font.custom("Inter_Semibold18", size: 18)
        case .interSemibold24:
            return Font.custom("Inter_Semibold24", size: 24)
        case .interSemibold28:
            return Font.custom("Inter_Semibold28", size: 28)
        }
    }
}
