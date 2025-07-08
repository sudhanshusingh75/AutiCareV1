//
//  EmailEntryStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 06/07/25.
//

import SwiftUI
import FirebaseAuth

struct EmailEntryStep: View {
    @ObservedObject var viewModel: RegistrationFlowViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var nextStep: RegistrationStep
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading,spacing: 10) {
                    Text("What's Your Email Address?")
                        .font(.title.bold())
                    Text("Enter the Email Address at Which You can be Contacted. No one will see this on your profile.")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                InputView(text: $viewModel.email, title: "Email", placeholder: "Email Address")
                InputView(text: $viewModel.password, title: "Password", placeholder: "Password", isSecureField: true)
                InputView(text: $viewModel.confirmPassword, title: "Confirm Password", placeholder: "Confirm Password", isSecureField: true)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button {
                    if !viewModel.isValidEmail(viewModel.email) {
                        errorMessage = "Please enter a valid email address."
                        showError = true
                        return
                    }
                    if let passwordError = viewModel.passwordValidationMessage(viewModel.password) {
                        errorMessage = passwordError
                        showError = true
                        return
                    }
                    if viewModel.password != viewModel.confirmPassword {
                        errorMessage = "Passwords do not match."
                        showError = true
                        return
                    }
                    
                    if !isLoading {
                        isLoading = true
                        Task {
                            do {
                                try await Auth.auth().createUser(withEmail: viewModel.email, password: viewModel.password)
                                try await authViewModel.sendVerificationEmail()
                                nextStep = .emailVerification
                            } catch {
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                            isLoading = false
                        }
                    }
                    
                } label: {
                    Text("Next")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color(red: 0, green: 0.387, blue: 0.5))
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an Account?")
                        Text("Sign In")
                        
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.systemGray))
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EmailEntryStep(viewModel: RegistrationFlowViewModel(), nextStep: .constant(.emailVerification))
}
