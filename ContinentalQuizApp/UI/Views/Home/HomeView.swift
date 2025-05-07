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
        VStack(spacing: 0) {
            TopOrangeView()
            HeaderView()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .onAppear {
            
        }
    }
    
    private func TopOrangeView() -> some View {
        Rectangle()
            .fill(Colors.orange_FF7043)
            .frame(height: 100)
    }
    
    private func HeaderView() -> some View {
        HStack {
            TimerView()
            Title()
        }
        .padding(.top, 15)
        .padding(.horizontal, 5)
    }
    
    private func TimerView() -> some View {
        VStack {
            Text("00:10")
                .foregroundStyle(.white)
                .padding(20)
        }
        .background(.black)
        .cornerRadius(10, corners: [.topLeft, .topRight, .bottomRight])
    }
    
    private func Title() -> some View {
        Text("FLAGS CHALLENGE")
            .foregroundStyle(Colors.orange_FF7043)
            .font(AppFont.interSemibold18.returnFont())
            .shadow(color: .gray, radius: 2, x: 0, y: 4)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    HomeView()
}
