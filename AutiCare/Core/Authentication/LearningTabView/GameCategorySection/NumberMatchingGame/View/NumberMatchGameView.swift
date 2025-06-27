//
//  NumberMatchGameView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 27/06/25.
//

import SwiftUI

struct NumberMatchGameView: View {
    @StateObject private var viewModel = NumberMatchViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Match the number:")
                .font(.title)
            
            Text("\(viewModel.currentNumber)")
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.blue)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 20) {
                ForEach(viewModel.options) { item in
                    MatchItemView(item: item)
                        .onTapGesture {
                            viewModel.checkMatch(for: item)
                    }
                }
            }
            
            if viewModel.showCorrect {
                Text("✅ Correct!")
                    .font(.title2)
                    .foregroundColor(.green)
                    .transition(.scale)
            }
        }
        .padding()
    }
}


#Preview {
    NumberMatchGameView()
}
