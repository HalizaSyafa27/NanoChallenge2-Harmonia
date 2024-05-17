//
//  QuizViewModel.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 16/05/24.
//

import SwiftUI
import AVFoundation

class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var quiz: [Song] = [
        Song(id: "0", title: "Kupu kupu", artist: "Tiara Andini", fileName: "Kupu kupu", options: ["Kupu kupu", "Jatuh Cinta", "Gemintang Hati", "Panah Asmara"]),
        Song(id: "1", title: "Panah Asmara", artist: "Afgan", fileName: "Panah Asmara", options: ["Sadis", "Bukan Cinta Biasa", "Terima Kasih Cinta", "Panah Asmara"]),
        Song(id: "2", title: "Rodeo", artist: "Lah Pat", fileName: "Rodeo", options: ["That Boy", "Rodeo", "Cowboy", "Ranch"]),
        Song(id: "3", title: "Lover", artist: "Taylor Swift", fileName: "Lover", options: ["Blank Space", "Love Story", "Lover", "You Belong with Me"]),
        Song(id: "4", title: "Losing Us", artist: "Raisa Anggini", fileName: "Losing Us", options: ["Let Go", "Losing Us", "Losing You", "Regret"]),
        Song(id: "5", title: "Bejeweled", artist: "Taylor Swift", fileName: "Bejeweled", options: ["Bejeweled", "August", "Cruel Summer", "All to Well"])
        // Tambahkan lebih banyak lagu
    ]
    
    @Published var selectedOption: String? = nil
    @Published var isAnswerCorrect: Bool? = false
    @Published var showOptions = true
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(fileName: String, duration: TimeInterval = 30) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                    
                    // Schedule stopping the audio after the specified duration
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                        self?.audioPlayer?.stop()
                    }
                } catch {
                    print("Error playing sound: \(error.localizedDescription)")
                }
            }
        }
    
    func validateAnswer(selectedOption: String) {
        self.selectedOption = selectedOption
        
        // Dapatkan judul lagu yang benar (jawaban yang benar) dari kuis saat ini
        let correctAnswer = quiz[currentQuestionIndex].title
        
        // Bandingkan opsi yang dipilih dengan jawaban yang benar
        if selectedOption == correctAnswer {
            isAnswerCorrect = true
            score += 1 // Tambah skor jika jawaban benar
        } else {
            isAnswerCorrect = false
        }
    }

    
    func nextQuestion() {
           currentQuestionIndex += 1
           selectedOption = nil
           isAnswerCorrect = nil
           showOptions = true
       }
    
    func resetGame() {
        currentQuestionIndex = 0
        score = 0
        selectedOption = nil
        isAnswerCorrect = nil
        showOptions = true
    }
}

