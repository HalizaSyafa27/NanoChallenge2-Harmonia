//
//  ChooseLevelView.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 20/05/24.
//

import SwiftUI

struct ChooseLevelView: View {
    
    var body: some View {
        NavigationStack{
            ZStack{
                    Image("ChooseLevel")
                                .resizable()
                                .ignoresSafeArea()
                                
                    VStack{
                        NavigationLink(destination: EasyQuestionView()) {
                                        PrimaryButton(text: "Original Voice", width: 300, height: 50, fontSize: 24)
                                        .padding()
                                           }
                        
                        NavigationLink(destination: HardQuestionView()) {
                                        PrimaryButton(text: "Mystery Voice", width: 300, height: 50, fontSize: 24)
                                        .padding()
                                           }
                        
                    }
                    .padding(.bottom, 100)
                }
        }
    
        
    }
}

#Preview {
    ChooseLevelView()
}
