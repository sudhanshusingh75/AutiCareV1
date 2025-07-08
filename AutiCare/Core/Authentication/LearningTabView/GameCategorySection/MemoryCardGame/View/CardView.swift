//
//  CardView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI


struct CardView: View {
    let card: MemoryCard
    
    var body: some View {
        ZStack {
            if card.isFlipped || card.isMatched {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 2)
                Image(systemName: card.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(10)
                    .foregroundColor(.blue)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            }
        }
        .frame(width: 80, height: 80)
        .animation(.easeInOut(duration: 0.3), value: card.isFlipped)
    }
}

