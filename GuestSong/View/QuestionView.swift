//
//  Questionview.swift
//  GuestSong
//
//  Created by Haliza Syafa Oktaviani on 16/05/24.
//

import SwiftUI

struct QuestionView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var isAnimating = false
    @State private var showOptions = false // menyembunyikan opsi
    @State private var showAlert = false
    
    var body: some View {
        ZStack{
            Image("Background")
                .ignoresSafeArea()
            
            VStack(spacing : 20){
                if viewModel.currentQuestionIndex < viewModel.quiz.count{
                    let currentSong = viewModel.quiz[viewModel.currentQuestionIndex]
                    
                    HStack {
                            Text("Guess The Song!")
                            .purpleTitle()
                            .padding(.top, 20)
                            Spacer()
                        Text("\(viewModel.currentQuestionIndex + 1) out \(viewModel.quiz.count)")
                                                    .foregroundColor(Color.text)
                                                    .fontWeight(.heavy)
                                                    .frame(height: 100)
                                                    .padding(.top, 20)
                     }
                     
                    ProgressBar(progress: CGFloat(viewModel.currentQuestionIndex) / CGFloat(viewModel.quiz.count))
            
                                        
                    
                     VStack{
                            AnimationView(name: "PlayButton", animationSpeed: 0.5)
                             .frame(width: 300, height: 300)
                             .onTapGesture {
                                 viewModel.playSound(fileName: currentSong.fileName, duration: 10)
                                                                isAnimating = true
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                                                    isAnimating = false
                                                                    showOptions = true
                                                                }
                                            }
                             .padding(.top, 80)
                             .padding(.bottom, 80)
                         if showOptions && !isAnimating {
                             ForEach(currentSong.options, id: \.self) { option in
                                 Button(action: {
                                     viewModel.validateAnswer(selectedOption: option)
                                     if let isCorrect = viewModel.isAnswerCorrect {
                                        if isCorrect {
                                            // Setelah 5 detik, sembunyikan opsi dan pindah ke lagu berikutnya
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                                showOptions = true
                                                viewModel.nextQuestion() // Pindah ke lagu selanjutnya
                                                showOptions = false
                                            }
                                        } else {
                                            // Jika jawaban salah, reset game
                                            showAlert = true
                                       }
                                  }
                                    
                                 }) {
                                     Text(option)
                                         .padding()
                                         .frame(width: 300)
                                         .background(
                                             viewModel.selectedOption == option ?
                                             (viewModel.isAnswerCorrect == true ? Color.green : Color.red) :
                                             Color.button
                                         )
                                         .foregroundColor(.white)
                                         .cornerRadius(50)
                                         .padding(.vertical, 10)
                                 }
                                 .disabled(viewModel.selectedOption != nil) // Disable buttons after selection
                             }
                                                 }
                   }
                   Spacer()
                    
                }
                else {
                                    Text("Your Score: \(viewModel.score) out of \(viewModel.quiz.count)")
                                        .purpleTitle()
                                        .padding()
                                    
                                    Button(action: {
                                        viewModel.resetGame()
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
               .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Whoops! You are wrong"),
                        message: Text("Try again!"),
                        dismissButton: .default(Text("OK")) {
                                    // Di sini, atur kembali showOptions ke true
                                    showOptions = false
                                    // Kemudian reset permainan
                                    viewModel.resetGame()
                                }                    )
                }
           }
       }
               

#Preview {
    QuestionView()
}
