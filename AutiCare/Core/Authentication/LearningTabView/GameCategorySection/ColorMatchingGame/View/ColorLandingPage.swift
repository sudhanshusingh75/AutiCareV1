//
//  ColorLandingPage.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 04/07/25.
//

import SwiftUI

struct ColorLandingPage: View {
    var body: some View {
        NavigationStack{
            ZStack{
                PastelBlobBackgroundView()
                VStack(spacing: 24)
                {
                    Text("Color Match Game")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                    
                    NavigationLink {
                        ColorMatchingGameView()
                    } label: {
                        Text("Start Matching")
                            .font(.headline.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .padding(.horizontal,100)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ColorLandingPage()
}
