//
//  ContentView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel:AuthViewModel
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    var body: some View {
        Group{
            if !hasSeenOnboarding{
                OnboardingScreen()
            }
            else if viewModel.userSession != nil{
                TabBarView()
            }
            else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
