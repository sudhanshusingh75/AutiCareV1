//
//  EmailPasswordStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 06/07/25.
//

import SwiftUI
import FirebaseAuth
struct EmailPasswordStep: View {
    @ObservedObject var viewModel: RegistrationFlowViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var nextStep: RegistrationStep

    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 16) {
            InputView(text: $viewModel.email, title: "Email", placeholder: "you@example.com")
                .autocapitalization(.none)

            InputView(text: $viewModel.password, title: "Password", placeholder: "••••••", isSecureField: true)

            InputView(text: $viewModel.confirmPassword, title: "Confirm Password", placeholder: "••••••", isSecureField: true)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Continue") {
                Task {
                    if !viewModel.isValidEmail(viewModel.email) {
                        errorMessage = "Invalid email format."
                        return
                    }

                    if viewModel.password != viewModel.confirmPassword {
                        errorMessage = "Passwords do not match."
                        return
                    }

                    if !viewModel.isValidPassword(viewModel.password) {
                        errorMessage = "Password must be at least 6 characters with a number and special character."
                        return
                    }

                    do {
                        try await Auth.auth().createUser(withEmail: viewModel.email, password: viewModel.password)
                        try await authViewModel.sendVerificationEmail()
                        nextStep = .emailVerification
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.confirmPassword.isEmpty)
        }
        .padding()
    }
}



#Preview {
    EmailPasswordStep(viewModel: RegistrationFlowViewModel(), nextStep: .constant(.emailVerification))
}
