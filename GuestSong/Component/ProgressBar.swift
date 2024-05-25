//
//  ProgressBar.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 16/05/24.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .frame(maxWidth: 800, maxHeight: 20)
                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.564, opacity: 0.327))
                .cornerRadius(10)
            
            Rectangle()
//                .frame(width: progress, height: 4)
                .frame(width: min(progress, 1.0) * 800, height: 20)
                .foregroundColor(Color.wrongOption)
                .cornerRadius(10)
        }
    }
}

#Preview {
//    ProgressBar(progress: 10)
    ProgressBar(progress: 0.01)
}
