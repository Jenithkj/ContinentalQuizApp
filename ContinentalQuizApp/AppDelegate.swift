//
//  AppDelegate.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 21/05/25.
//

import Foundation
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
