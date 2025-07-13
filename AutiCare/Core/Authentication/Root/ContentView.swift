//
//  ContentView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        Group {
            if viewModel.isLoading {
               SplashScreen()// Wait here until auth state is known
            } else if !hasSeenOnboarding {
                OnboardingScreen()
            } else if viewModel.userSession == nil {
                LoginView()
            } else if viewModel.emailVerfied == false {
                if viewModel.userSession != nil {
                    RegistrationFlow(currentStep: .emailVerification)
                } else {
                    RegistrationFlow(currentStep: .emailEntry)
                }
            } else if viewModel.completedSignUp {
                TabBarView()
            } else {
                ProfileCompletionFlow()
            }
        }
        .onAppear {
            if viewModel.isLoading == false {
                viewModel.isLoading = true // explicitly show Splash until state refreshes
            }
            Task {
                await viewModel.refreshAuthState()
            }
        }
    }
}


#Preview {
    ContentView()
}
