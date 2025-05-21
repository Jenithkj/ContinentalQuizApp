//
//  ContinentalQuizAppApp.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 06/05/25.
//

import SwiftUI

@main
struct ContinentalQuizAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isSplashActive = true

    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                AnimatedWordSplashView(isActive: $isSplashActive)
            } else {
                HomeView()
            }
        }
    }
}
