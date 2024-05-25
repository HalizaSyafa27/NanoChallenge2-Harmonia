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
    @Published var isEasyQuiz = true
    @Published var easyQuiz: [Song] = [
        //easy level
        Song(id: "0", title: "Kupu kupu", artist: "Tiara Andini", fileName: "Kupu kupu", options: ["Kupu kupu", "Jatuh Cinta", "Gemintang Hati", "Panah Asmara"]),
        Song(id: "1", title: "Panah Asmara", artist: "Afgan", fileName: "Panah Asmara", options: ["Sadis", "Bukan Cinta Biasa", "Terima Kasih Cinta", "Panah Asmara"]),
        Song(id: "2", title: "Rodeo", artist: "Lah Pat", fileName: "Rodeo", options: ["That Boy", "Rodeo", "Cowboy", "Ranch"]),
        Song(id: "3", title: "Lover", artist: "Taylor Swift", fileName: "Lover", options: ["Blank Space", "Love Story", "Lover", "You Belong with Me"]),
        Song(id: "4", title: "Losing Us", artist: "Raisa Anggini", fileName: "Losing Us", options: ["Let Go", "Losing Us", "Losing You", "Regret"]),
        Song(id: "5", title: "Best Part", artist: "Daniel Caesar", fileName: "Best Part", options: ["Best Part", "August", "Cruel Summer", "All to Well"]),
        Song(id: "6", title: "Backburner", artist: "NIKI", fileName: "Backburner", options: ["Lose", "Backburner", "Take a Chance With Me", "Every Summertime"]),
        Song(id: "7", title: "Keep You Safe", artist: "Yahya", fileName: "Keep You Safe", options: ["Understand", "Cherry Wine", "Ur So Pretty", "Keep You Safe"]),
        Song(id: "8", title: "It Will Rain", artist: "Bruno Mars", fileName: "It Will Rain", options: ["It Will Rain", "Nothing", "Home", "Easily"]),
        Song(id: "9", title: "Cantik", artist: "Kahitna", fileName: "Cantik", options: ["Soulmate", "Andai Dia Tahu", "Cantik", "Takkan Terganti"])
    ]
    
    @Published var hardQuiz: [Song] = [
        //hard level
                Song(id: "0", title: "The Man That Cant be Moved", artist: "The Script", fileName: "The Man That Cant be Moved", options: ["Love Me", "The Man That Cant be Moved", "First Move", "All to Well"]),
                Song(id: "1", title: "How Deep Is Your Love", artist: "Bee Gees", fileName: "How Deep Is Your Love", options: ["How Deep Is Your Love", "Night Fever", "Tragedy", "Immortality"]),
                Song(id: "2", title: "Love In The Dark", artist: "Adele", fileName: "Love In The Dark", options: ["Love In The Dark", "All I Ask", "Someone Like You", "When We Were Young"]),
                Song(id: "3", title: "Eenie Meenie", artist: "Justin Bieber", fileName: "Eenie Meenie", options: ["Baby", "Favourite Girl", "Eenie Meenie", "One Time"]),
                Song(id: "4", title: "Nobody Gets Me", artist: "SZA", fileName: "Nobody Gets Me", options: ["Saturn", "Nobody Gets Me", "Kill Bill", "All The Stars"]),
                Song(id: "5", title: "She Will be Loved", artist: "Maroon 5", fileName: "She Will be Loved", options: ["She Will be Loved", "One More Night", "Sugar", "Payphone"]),
                Song(id: "6", title: "Alkohol", artist: "Sisitipsi", fileName: "Alkohol", options: ["Aroma Dia", "Masih Kurang", "Paling Bisa", "Alkohol"]),
                Song(id: "7", title: "Nuansa Bening", artist: "Vidi Aldiano", fileName: "Nuansa Bening", options: ["Status Palsu", "Nuansa Bening", "Aku Cinta Dia", "Cinta Jangan Kau Pergi"]),
                Song(id: "8", title: "Guilty As Sin", artist: "Taylor Swift", fileName: "Guilty As Sin", options: ["Fearless", "Guilty As Sin", "Enchanted", "Style"]),
                Song(id: "9", title: "Cari Pacar Lagi", artist: "ST12", fileName: "Cari Pacar Lagi", options: ["Putri Iklan", "Cinta Tak Harus Memiliki", "Jangan Pernah Berubah", "Cari Pacar Lagi"])
    ]
    
    @Published var selectedOption: String? = nil
    @Published var isAnswerCorrect: Bool? = false
    @Published var showOptions = true
    @Published var showSoundwave = false
    @Published var timeRemaining = 30
    @Published var isQuizFinished = false
    @Published var showCountdown = false
    @Published var showDetailSong = false
    var correctAnswer: String? = nil
    var initialTime: Int {
        return isEasyQuiz ? 30 : 15
    }
    
    
    private var audioPlayer: AVAudioPlayer?
    private var countdownTimer: Timer?
    
    func playSound(fileName: String) {
        print("Playing sound: \(fileName)")
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    

    func startNewQuestion() {
         resetQuestionState()

         if currentQuestionIndex == 0 {
             showCountdown = true
             DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                 self.prepareQuestion()
             }
         } else {
             hideDetailSongView()
             prepareQuestion()
         }
     }


     func prepareQuestion() {
         showCountdown = false
         showSoundwave = true
         let currentQuiz = isEasyQuiz ? easyQuiz : hardQuiz
         print("Preparing question: \(currentQuiz[currentQuestionIndex].title)")
         playSound(fileName: currentQuiz[currentQuestionIndex].fileName)
         showOptions = true
         startTimer()
     }

     func validateAnswer(selectedOption: String) {
         self.selectedOption = selectedOption
         let currentQuiz = isEasyQuiz ? easyQuiz : hardQuiz
         let correctAnswer = currentQuiz[currentQuestionIndex].title
         self.correctAnswer = correctAnswer
         isAnswerCorrect = selectedOption == correctAnswer
         
         if isAnswerCorrect == true {
             score += 1
         }
         stopTimerAndHighlightAnswers()
     }

     func startTimer() {
         timeRemaining = initialTime
         countdownTimer?.invalidate()
         countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
             guard let self = self else { return }
             if self.timeRemaining > 0 {
                 self.timeRemaining -= 1
             } else {
                 self.stopTimerAndHighlightAnswers()
             }
         }
     }

     func stopTimerAndHighlightAnswers() {
         stopTimer()
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             self.showDetailSongView()
         }
     }

     func stopTimer() {
         countdownTimer?.invalidate()
     }

    func goToNextQuestion() {
        let currentQuiz = isEasyQuiz ? easyQuiz : hardQuiz
        if currentQuestionIndex < currentQuiz.count - 1 {
            currentQuestionIndex += 1
            self.startNewQuestion()
        } else {
            finishQuiz()
        }
        
    }
    
     func finishQuiz() {
         showDetailSong = false
         showSoundwave = false
         showOptions = false
         showCountdown = false
         isQuizFinished = true
         stopAudioAndTimer()
     }

     func stopAudioAndTimer() {
         stopTimer()
         audioPlayer?.stop()
     }

     func showDetailSongView() {
         showSoundwave = false
         showDetailSong = true
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             self.showDetailSong = false
             self.showSoundwave = true
             self.goToNextQuestion()
         }
     }
     
     func hideDetailSongView() {
         showSoundwave = true
         showDetailSong = false
     }

     func resetQuestionState() {
         selectedOption = nil
         isAnswerCorrect = nil
         showOptions = false
         showSoundwave = false
         showDetailSong = false
     }
     
     func resetGame() {
         currentQuestionIndex = 0
         isQuizFinished = false
         score = 0
         startNewQuestion()
     }
 }
