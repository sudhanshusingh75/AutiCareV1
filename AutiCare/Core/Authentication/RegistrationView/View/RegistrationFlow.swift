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
    @State private var currentStep: RegistrationStep = .emailEntry

    var body: some View {
        VStack {
            switch currentStep {
            case .fullName:
                FullNameStep(viewModel: viewModel, nextStep: $currentStep)
            case .dobGender:
                DOBGenderStep(viewModel: viewModel, nextStep: $currentStep)
            case .profilePhoto:
                ProfilePhotoStep(viewModel: viewModel, nextStep: $currentStep)
            case .emailEntry:
                EmailEntryStep(viewModel: viewModel, nextStep: $currentStep)
            case .emailVerification:
                EmailVerificationStep(step: $currentStep)
            case .review:
                ReviewStep(viewModel: viewModel)
                    .environmentObject(authViewModel)
            }
        }
        .animation(.easeInOut, value: currentStep)
        .transition(.slide)
    }
}

#Preview {
    RegistrationFlow()
        .environmentObject(AuthViewModel())
}
