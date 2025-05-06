//
//  ContinentalQuizAppApp.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 06/05/25.
//

import SwiftUI

@main
struct ContinentalQuizAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
