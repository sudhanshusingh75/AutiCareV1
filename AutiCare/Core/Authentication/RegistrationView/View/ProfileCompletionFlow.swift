//
//  ProfileCompletionFlow.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 13/07/25.
//

import SwiftUI

struct ProfileCompletionFlow: View {
    @StateObject private var viewModel = RegistrationFlowViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentStep: ProfileCompletionStep = .fullName
    var body: some View {
        VStack {
            switch currentStep {
            case .fullName:
                FullNameStep(viewModel: viewModel, nextStep: $currentStep)
            case .dobGender:
                DOBGenderStep(viewModel: viewModel, nextStep: $currentStep)
            case .profilePhoto:
                ProfilePhotoStep(viewModel: viewModel, nextStep: $currentStep)
            case .review:
                ReviewStep(viewModel: viewModel)
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    ProfileCompletionFlow()
}
