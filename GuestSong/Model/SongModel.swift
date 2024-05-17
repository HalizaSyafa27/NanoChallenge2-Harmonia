//
//  SongModel.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 16/05/24.
//

import Foundation
import SwiftUI

struct Song: Identifiable {
    let id: String
    let title: String
    let artist: String
    let fileName: String
    let options: [String]
}
