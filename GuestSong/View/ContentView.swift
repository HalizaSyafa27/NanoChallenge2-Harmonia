//
//  ContentView.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 15/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background-rev")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        NavigationLink(destination: ChooseLevelView()) {
                            PrimaryButton(text: "Start", width: 200, height: 50, fontSize: 24)
                        }
                        .padding(.top, 300)
                    }
                  
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    ContentView()
}
