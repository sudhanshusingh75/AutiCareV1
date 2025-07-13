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
    @State private var emailErrorMessage: String = ""
    @State private var passwordErrorMessage: String = ""
    @State private var confirmPasswordErrorMessage: String = ""

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
                
                InputView(text: $viewModel.email, title: "Email", placeholder: "Email Address",errorMessage: emailErrorMessage)
                    .textInputAutocapitalization(.never)
                    .onChange(of: viewModel.email) {_,_ in
                        validateEmail()
                    }
                InputView(text: $viewModel.password, title: "Password", placeholder: "Password", isSecureField: true,errorMessage: passwordErrorMessage)
                    .onChange(of: viewModel.password) {_,_ in
                        validatePassword()
                    }
                InputView(text: $viewModel.confirmPassword, title: "Confirm Password", placeholder: "Confirm Password", isSecureField: true,errorMessage: confirmPasswordErrorMessage)
                    .onChange(of: viewModel.confirmPassword) { _, _ in
                        validateConfirmPassword()
                    }
//                if showError {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .font(.caption)
//                }
                Button {
                    validateEmail()
                    validatePassword()
                    validateConfirmPassword()
                    guard emailErrorMessage.isEmpty,
                          passwordErrorMessage.isEmpty,
                          confirmPasswordErrorMessage.isEmpty else {
                        showError = true
                        errorMessage = "Please fix the errors above."
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
    private func validateEmail() {
        if !isValidEmail(viewModel.email) {
            emailErrorMessage = "Please enter a valid email address."
        } else {
            emailErrorMessage = ""
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword() {
        if !isValidPassword(viewModel.password) {
            passwordErrorMessage = "Password must be at least 6 characters long and include 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character."
        } else {
            passwordErrorMessage = ""
        }
    }
    
    private func validateConfirmPassword() {
        if viewModel.password != viewModel.confirmPassword {
            confirmPasswordErrorMessage = "Password and Confirm Password do not match."
        } else {
            confirmPasswordErrorMessage = ""
        }
    }
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }
}

#Preview {
    EmailEntryStep(viewModel: RegistrationFlowViewModel(), nextStep: .constant(.emailVerification))
}
