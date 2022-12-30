//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by SemikSS on 28.12.2022.
//

import SwiftUI

struct ContentView: View {
    let choices = ["🪨", "📃", "✂️"]
    
    @State private var currentChoice = Int.random(in: 0...2)
    @State private var playerMustWin = Bool.random()
    @State private var playerChoise = ""
    @State private var alertText = ""
    @State private var score = 0
    @State private var showResult = false
    
    var correctChoice: String {
        let correctChoices = ["📃", "✂️", "🪨"]
        return correctChoices[currentChoice]
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .blue], startPoint: .top, endPoint: .bottom)
            
            VStack {
                Text("Player must \(playerMustWin ? "win" : "lose")")
                    .font(.title.bold())
                
                ZStack {
                    LinearGradient(colors: [.blue, .secondary], startPoint: .top, endPoint: .bottom)
                    
                    HStack {
                        ForEach(choices, id: \.self) { choice in
                            Button(choice) {
                                buttonTapped(choice)
                            }
                            .padding()
                            .font(.system(size: 50))
                        }
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                
                Text("Score: \(score)")
                    .font(.title.bold())
            }
        }
        .ignoresSafeArea()
        .alert(alertText , isPresented: $showResult) {
            Button ("continue", action: askQuestion)
        } message: {
            Text("my choice was: \(choices[currentChoice])")
        }
    }
    
    func buttonTapped (_ choice: String) {
        playerChoise = choice
        let condition = (playerChoise == correctChoice && playerMustWin) || (playerChoise != correctChoice && !playerMustWin)
        
        if condition {
            score += 1
            alertText = "You win!"
        } else {
            alertText = "You lose =("
        }
        
        showResult = true
    }
    
    func askQuestion() {
        currentChoice = Int.random(in: 0...2)
        playerMustWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
