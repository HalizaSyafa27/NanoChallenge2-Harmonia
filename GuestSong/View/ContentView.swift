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
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        Text("Guess Song")
                            .purpleTitle()
                        
                        Text("Ready to guess the song?")
                            .foregroundColor(Color.text)
                    }
                    NavigationLink(destination: QuestionView()) {
                        PrimaryButton(text: "Start")
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
