//
//  Questionview.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 16/05/24.
//

import SwiftUI

struct EasyQuestionView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var isCorrectAnswer: Bool?
    @State private var isFinalizing = false
    @State private var showDetail = false
    @State private var selectedSong: Song?
//    var song: Song
    
    var body: some View {
        ZStack {
            Image("QuestionView")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 20) {
             
                if !viewModel.isQuizFinished {
                    if viewModel.currentQuestionIndex < viewModel.easyQuiz.count {
                        let currentSong = viewModel.easyQuiz[viewModel.currentQuestionIndex]
                        
                        HStack {
                            Text("Time: \(viewModel.timeRemaining) seconds")
                                .padding(.top, 30)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(viewModel.currentQuestionIndex+1) out of \(viewModel.easyQuiz.count)")
                                .foregroundColor(Color.black)
                                .fontWeight(.bold)
                                .frame(height: 10)
                                .padding(.top, 30)
                        }
                       
                        ProgressBar(progress: CGFloat(viewModel.currentQuestionIndex) / CGFloat(viewModel.easyQuiz.count))
                      
                        VStack {
                            if viewModel.showCountdown {
                                AnimationView(name: "NewTimeCountdown", animationSpeed: 0.5)
                                    .frame(width: 200, height: 200)
                            } else if viewModel.showSoundwave {
                                AnimationView(name: "soundWave2", animationSpeed: 0.5)
                                    .frame(width: 189, height: 189)
                            } else if viewModel.showDetailSong {
                                HStack(spacing: 100) {
                                    Image(currentSong.fileName)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(10)
                                        .padding()

                                    VStack(alignment: .leading) {
                                        Text(currentSong.title)
                                            .font(.title)
                                            .fontWeight(.bold)

                                        Text(currentSong.artist)
                                            .font(.title2)
                                    }
                                }
                                .transition(.opacity)
                               
                            }

                            
                            if viewModel.showOptions {
                                                            // Grid layout with 2 columns
                                                            LazyVGrid(columns: [GridItem(.flexible(), spacing: -170), GridItem(.flexible(), spacing: 0)], spacing: 20) {
                                                                
                                                                ForEach(currentSong.options, id: \.self) { option in
                                                                    Button(action: {
                                                                        if viewModel.selectedOption == nil {
                                                                                            viewModel.validateAnswer(selectedOption: option)
                                                                                            isCorrectAnswer = viewModel.isAnswerCorrect
                                                                                            selectedSong = currentSong
                                                                                            showDetail = true
                                                                                        }
                                                                       
                                                                    }) {
                                                                        Text(option)
                                                                            .padding()
                                                                            .frame(width: 240, height: 120) // Adjusted width to fit 2 columns
                                                                            .background(
                                                                                viewModel.selectedOption == option ?
                                                                                                                                    (isCorrectAnswer == true ? Color.correctOption : Color.wrongOption) :
                                                                                                                                    (option == viewModel.correctAnswer ? Color.correctOption : Color.button)
                                                                            )
                                                                            .foregroundColor(.black)
                                                                            .cornerRadius(30)
                                                                            .overlay(
                                                                                RoundedRectangle(cornerRadius: 30)
                                                                                    .stroke(
                                                                                        viewModel.selectedOption == option ?
                                                                                        (isCorrectAnswer == true ? Color.green : Color.red) :
                                                                                        (option == viewModel.correctAnswer ? Color.green : Color.clear),
                                                                                        lineWidth: 4
                                                                                    )
                                                                            )
                                                                    }
                                                                    .disabled(viewModel.selectedOption != nil)
                                                                }
                                                            }
                                                            .padding(.top, 10)
                                                        }
                        }
                        Spacer()
                    }
                } else {
                    
                    AnimationView(name: "Congrats", animationSpeed: 0.5)
                        .frame(width: 300, height: 300)
                        .padding(.top, 150)
                    Text("Your Score: \(viewModel.score) out of \(viewModel.easyQuiz.count)")
                        .padding()
                    
                    Button(action: {
                        viewModel.resetGame()
                    }) {
                        Text("Play Again")
                            .padding()
                            .background(Color.button)
                            .foregroundColor(.black)
                            .cornerRadius(50)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.timeRemaining = viewModel.initialTime
            viewModel.startNewQuestion()
        }
    }
}

#Preview {
    EasyQuestionView()
}
