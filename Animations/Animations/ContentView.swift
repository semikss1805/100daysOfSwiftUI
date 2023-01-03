//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by SemikSS on 28.12.2022.
//

import SwiftUI

struct FlagTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.largeTitle.bold())
    }
}

extension View {
    func flagTitle() -> some View {
        modifier(FlagTitle())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var gameStage = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var flagRotations = [0.0, 0.0, 0.0]
    @State private var flagOpacity = [1.0, 1.0, 1.0]
    @State private var correctAnswer = Int.random(in: 1...2)
    
    struct FlagImage: View {
        var number: Int
        var countries: [String]
        
        init(_ number: Int, _ countries: [String]) {
            self.number = number
            self.countries = countries
        }
        
        var body: some View {
            Image(countries[number])
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient.init(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .flagTitle()
                
                VStack {
                    VStack(spacing: 15) {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                        }
                        
                        ForEach(0..<3) { number in
                            Button {
                                withAnimation {
                                    flagRotations[number] += 360
                                }
                                flagTapped(number)
                            } label: {
                                FlagImage(number, countries)
                            }
                            .rotation3DEffect(.degrees(flagRotations[number]),
                                              axis: (x: 0, y: 1, z: 0))
                            .opacity(flagOpacity[number])
                            .scaleEffect(flagOpacity[number])
                            .animation(.default, value: flagOpacity)
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
                    .flagTitle()
                
                Spacer()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(totalScore)")
            }
        }
        .ignoresSafeArea()
        .alert("The end, your final score is \(totalScore)/\(gameStage)", isPresented: $showingFinalScore) {
            Button("Restart", action: restart)
        }
    }
    
    func flagTapped(_ number: Int) {
        for i in 0...2 {
            if i != number {
                flagOpacity[i] = 0.25
            }
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        
        gameStage += 1
        showingScore = true
        
        if gameStage == 4 {
            showingFinalScore = true
        }
    }
    
    func askQuestion() {
        withAnimation {
            flagOpacity = flagOpacity.map { $0 != 1.0 ? 1.0 : $0}
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
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
