//
//  Extensions.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 15/05/24.
//

import Foundation
import SwiftUI

extension Text{
    func purpleTitle() -> some View{
        self.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(.heavy)
            .foregroundColor(Color.text)
    }
}
