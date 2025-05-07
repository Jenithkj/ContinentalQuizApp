//
//  HomeView.swift
//  ContinentalQuizApp
//
//  Created by Jenith KJ on 06/05/25.
//

import SwiftUI
import CoreData

struct HomeView: View {

    var body: some View {
        VStack {
            TopOrangeView()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }
    
    private func TopOrangeView() -> some View {
        Rectangle()
            .fill(Colors.orange_FF7043)
            .frame(height: 100)
    }
}

#Preview {
    HomeView()
}
