//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anthony Glayzer on 10/12/2021.
//

import SwiftUI

struct FlagImage: View {
    var image: Image
    //@State var animationAmount = 0.0
    
    var body: some View {
        image
            .renderingMode(.original)
            //.clipShape(Capsule())
            .clipShape(RoundedRectangle(cornerRadius:10))
            .shadow(radius: 5)
            //.rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func bigBlueTitle() -> some View {
        modifier(BlueTitle())
    }
}

struct ContentView: View {
    @State private var scoreTitle = ""
    @State private var showingScore = false
    static let allCountries = ["Estonia","France","Germany","Ireland","Italy","Monaco","Nigeria","Poland","Russia","Spain","UK","US"]
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var showingGameOver = false
    @State private var tries = 0
    @State private var tappedFlagNum = -1
    
    @State private var animationAmount = 0.0
    @State private var fadeAmount = 0.25
    @State private var scaleAmount = 0.8
    
    var body: some View {
        ZStack {
            //LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                //.ignoresSafeArea()
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            //tappedFlagNum = number
                            
                            //withAnimation {
                                //animationAmount += 360
                                //fadeAmount -= 0.75
                                //scaleAmount -= 0.2
                            //}
                            
                            
                        } label: {
                            //FlagImage(image: Image(countries[number]))
                            Image(countries[number])
                                .renderingMode(.original)
                                //.clipShape(Capsule())
                                .clipShape(RoundedRectangle(cornerRadius:10))
                                .shadow(color: .black, radius: 10)
                                .rotation3DEffect(.degrees(tappedFlagNum == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(tappedFlagNum != number && tappedFlagNum != -1 ? fadeAmount : 1)
                                .scaleEffect(tappedFlagNum != number && tappedFlagNum != -1 ? scaleAmount : 1)
                                .animation(.default, value: tappedFlagNum)
                        }
                        
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius:30))
                
                Spacer()
                Spacer()
                
                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle.prefix(7) == "Correct" {
                Text("You scored a point")
            } else {
                Text("You lost 1 point")
            }
        }
        
        .alert("Game Over", isPresented: $showingGameOver){
            Button("Restart Game", action: reset)
        } message: {
            switch score {
            case -8...0:
                Text("You scored \(score). You're really bad at this!")
            case 1...4:
                Text("You scored \(score). Better Luck Next Time!")
            case 5...7:
                Text("You scored \(score). Not bad, practice makes perfect!")
            default:
                Text("You scored \(score). You're a flag master!")
            }
        }
        
    }
    
    func flagTapped(_ number: Int) {
        tappedFlagNum = number
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Sorry, that's the flag of \(countries[number]) 😳"
            score -= 1
        }
        
        showingScore = true
        tries += 1
    }
    
    func askQuestion() {
        if tries == 8 {
            showingGameOver = true
        } else {
            if tries != 0 {
                countries.remove(at: correctAnswer)
            }
            tappedFlagNum = -1
            scaleAmount = 1.0
            fadeAmount = 0.25
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }

    func reset() {
        score = 0
        tries = 0
        countries = Self.allCountries
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
            .previewDisplayName("iPhone 13 Pro")

        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")
    }
}
