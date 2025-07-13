//
//  SplashScreen.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 13/07/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 16) {
                Image("Image0")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 1), value: animate)

                Text("AutiCare")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                    .scaleEffect(animate ? 1 : 0.8)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 1.2).delay(0.3), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    SplashScreen()
}

