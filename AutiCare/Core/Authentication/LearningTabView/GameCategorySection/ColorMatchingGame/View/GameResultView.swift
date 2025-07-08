//
//  ColorGameResultView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 04/07/25.
//
import SwiftUI
struct GameResultView: View {
    let score: Int
    let total: Int
    let onRestart: () -> Void
    let onQuit: () -> Void
    
    func feedbackForScore(_ score: Int, total: Int) -> (emoji: String, message: String, headline: String) {
        switch score {
        case 0...4:
            return (
                "😅",
                "Don't worry, keep practicing. You'll get it!",
                "You Gave It a Great Try!"
            )
        case 5...8:
            return (
                "👍",
                "Good job! You're getting the hang of it!",
                "Well Done!"
            )
        default:
            return (
                "🏆",
                "Excellent! You're a color matching master!",
                "Congratulations!"
            )
        }
    }
    var body: some View {
        let feedback = feedbackForScore(score, total: total)

        ZStack {
            PastelBlobBackgroundView()
            VStack(spacing: 30) {
                Text(feedback.headline)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("\(feedback.emoji)")
                    .font(.system(size: 150))
                
                Text(feedback.message)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Your Score: \(score) / \(total)")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                HStack(spacing: 20) {
                    Button("Play Again", action: onRestart)
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    
                    Button("Quit", action: onQuit)
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
    }
}


#Preview {
    GameResultView(score: 5, total: 10, onRestart: {}, onQuit: {})
}
