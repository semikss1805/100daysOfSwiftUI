//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by SemikSS on 28.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var gameStage = 0
    
    @State private var counries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 1...2)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.init(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                
                VStack {
                    VStack(spacing: 15) {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            
                            Text(counries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                        }
                        
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                Image(counries[number])
                                    .renderingMode(.original)
                                    .clipShape(Capsule())
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                .padding(15)
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(totalScore)")
        }
        .alert("The end, your final score is \(totalScore)/8", isPresented: $showingFinalScore) {
            Button("Restart", action: restart)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(counries[number])"
        }
        
        showingScore = true
        
        gameStage += 1
        
        if gameStage == 3 {
            showingFinalScore = true
        }
    }
    
    func askQuestion() {
        counries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart() {
        gameStage = 0
        totalScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
