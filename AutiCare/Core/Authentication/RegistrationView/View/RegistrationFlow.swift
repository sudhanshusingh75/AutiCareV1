//
//  RegistrationFlow.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI

struct RegistrationFlow: View {
    @StateObject private var viewModel = RegistrationFlowViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var currentStep: RegistrationStep
    var body: some View {
        VStack {
            switch currentStep {
            case .emailEntry:
                EmailEntryStep(viewModel: viewModel, nextStep: $currentStep)
            case .emailVerification:
                EmailVerificationStep(step: $currentStep)
            }
        }
        .animation(.easeInOut, value: currentStep)
        .transition(.slide)
    }
}

