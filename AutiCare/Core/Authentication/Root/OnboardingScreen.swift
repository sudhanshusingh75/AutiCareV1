//
//  OnboardingScreen.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/03/25.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    let onboardingData = [
            ("Welcome to AutiCare", "Helping autistic kids with interactive learning.", "onboarding1"),
            ("Community Support", "Connect with caregivers and share experiences.", "onboarding2"),
            ("Personalized Learning", "Tailored exercises and assessments for kids.", "onboarding3"),
            ("Start Your Journey", "Join us in making a difference!", "onboarding4")
        ]
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            
                            Text(onboardingData[index].0)
                                .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                            
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Image(onboardingData[index].2)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            
                            Text(onboardingData[index].1)
                                .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                HStack(alignment:.center) {
                    if currentPage < onboardingData.count - 1 {
                        
                        ButtonView(title: "Next") {
                            currentPage += 1
                        }
                    } else {
                        ButtonView(title: "Get Started") {
                            hasSeenOnboarding = true
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement:.topBarTrailing){
                    Button {
                        if currentPage < onboardingData.count - 1{
                            currentPage = onboardingData.count - 1
                        }
                    } label: {
                        Text("Skip")
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingScreen()
}
