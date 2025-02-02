//
//  PrimaryButton.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 15/05/24.
//

import SwiftUI

struct PrimaryButton: View {
    var text: String
    var background: Color = Color("AccentColor")
    var width: CGFloat?
    var height: CGFloat?
    var fontSize: CGFloat = 20 // Default font size parameter
    
    var body: some View {
        Text(text)
            .frame(width: width, height: height)
            .font(.system(size: fontSize))
            .foregroundColor(.black)
            .padding()
            .padding(.horizontal)
            .background(Color.button)
            .cornerRadius(100)
            .fontWeight(.bold)
            .shadow(color: Color.gray, radius: 4, x: 5, y: 6)
    }
}

#Preview {
    PrimaryButton(text: "Next")
}
