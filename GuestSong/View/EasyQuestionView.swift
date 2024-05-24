//
//  Questionview.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 16/05/24.
//

import SwiftUI

struct EasyQuestionView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var isAnimating = false
    @State private var showOptions = false // menyembunyikan opsi
    @State private var showAlert = false
    @State private var showCountdown = false
    @State private var showSoundwave = false
    @State private var showSoundwaveImage = false
    @State private var isCorrectAnswer: Bool?
    @State private var isFinalizing = false
    
    var body: some View {
        ZStack {
//            Rectangle()
//                .fill(Color.colorBackground)
//                .ignoresSafeArea(.all)
            Image("QuestionView")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 20) {
             
                if viewModel.currentQuestionIndex < viewModel.quiz.count {
                    let currentSong = viewModel.quiz[viewModel.currentQuestionIndex]
                    
                    HStack {
                        Text("Guess The Song!")
                            .padding(.top, 30)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(viewModel.currentQuestionIndex + 1) out \(viewModel.quiz.count)")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .frame(height: 10)
                            .padding(.top, 30)
                    }
                   
                    
                    ProgressBar(progress: CGFloat(viewModel.currentQuestionIndex) / CGFloat(viewModel.quiz.count))
                  
                    VStack {
                        if showCountdown {
                            AnimationView(name: "NewTimeCountdown", animationSpeed: 0.5)
                                .frame(width: 300, height: 300)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                                        showCountdown = false
                                        showSoundwave = true
                                        viewModel.playSound(fileName: currentSong.fileName, duration: 10)
                                        isAnimating = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                            isAnimating = false
                                            showOptions = true
                                            showSoundwave = false
                                            showSoundwaveImage = true
                                        }
                                    }
                                }
                                .padding(.top, 80)
                                .padding(.bottom, 80)
                        } else if showSoundwave {
                            AnimationView(name: "soundWave2", animationSpeed: 0.5)
                                .frame(width: 350, height: 300)
                                .padding(.top, 80)
                                .padding(.bottom, 80)
                        } else if showSoundwaveImage {
                            Image("SoundWave")
                                .resizable()
                                .frame(width: 350, height: 180)
                                .padding(.top, 20)
//                                .padding(.bottom, 5)
                        }
                        
                        if showOptions && !isAnimating {
                                                    ForEach(currentSong.options, id: \.self) { option in
                                                        Button(action: {
                                                            viewModel.validateAnswer(selectedOption: option)
                                                            isCorrectAnswer = viewModel.isAnswerCorrect
                                                            
                                                        }) {
                                                            Text(option)
                                                                .padding()
                                                                .frame(width: 500, height: 70)
                                                                .background(
                                                                    viewModel.selectedOption == option ?
                                                                    (isCorrectAnswer == true ? Color.correctOption : Color.wrongOption) :
                                                                    Color.button
                                                                )
                                                                .foregroundColor(.black)
                                                                .cornerRadius(50)
                                                                .padding(.vertical, 10)
                                                        }
                                                        .disabled(viewModel.selectedOption != nil)
                                                    }
                                                    
                                                    // Tombol "Next" selalu muncul setelah memilih opsi
                            if viewModel.selectedOption != nil {
                                PrimaryButton(
                                    text: isFinalizing ? "Finalizing..." : (viewModel.currentQuestionIndex == viewModel.quiz.count - 1 ? "Finalize Answer" : "Next"),
                                    background: Color.blue,
                                    width: 200,
                                    height: 50,
                                    fontSize: 24
                                    
                                )
                                .padding(.top, 30)
                                .onTapGesture {
                                               if isCorrectAnswer != nil && !isFinalizing {
                                                   if viewModel.currentQuestionIndex < viewModel.quiz.count - 1 {
                                                       // Jika bukan pertanyaan terakhir
                                                       showOptions = false
                                                       showSoundwaveImage = false
                                                       viewModel.nextQuestion()
                                                       
                                                       // Pastikan `currentSong` diperbarui dengan benar
                                                       let updatedSong = viewModel.quiz[viewModel.currentQuestionIndex]
                                                       
                                                       showCountdown = false
                                                       showSoundwave = true
                                                       viewModel.playSound(fileName: updatedSong.fileName, duration: 10)
                                                       isAnimating = true
                                                       DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                                           isAnimating = false
                                                           showOptions = true
                                                           showSoundwave = false
                                                           showSoundwaveImage = true
                                                       }
                                                   } else {
                                                       isFinalizing = true
                                                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                           // Tampilkan skor
                                                           showOptions = false
                                                           showSoundwaveImage = false
                                                           isFinalizing = false
                                                       }
                                                       viewModel.currentQuestionIndex += 1
                                                   }
                                               }
                                           }
                                       }
                                   }
                               }
                Spacer()

                } 
                else {
                    Text("Your Score: \(viewModel.score) out of \(viewModel.quiz.count)")
                        .padding()
                    
                    Button(action: {
                        viewModel.resetGame()
                        showCountdown = true
                        showSoundwave = false
                    }) {
                        Text("Play Again")
                            .padding()
                            .background(Color.button)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            showCountdown = true
        }
    }
}

#Preview {
    EasyQuestionView()
}
