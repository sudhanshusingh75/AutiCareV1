//
//  EmailVerificationStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 06/07/25.
//

import SwiftUI
import FirebaseAuth

struct EmailVerificationStep: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var step: RegistrationStep
    
    @State private var isSending = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading,spacing:10){
                Text("Verify Your Email")
                    .font(.title.bold())
                Text("We've sent a verification link to your email. Please verify to continue.")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                
                Button {
                    Task {
                        do {
                            try await authViewModel.refreshAuthState()
                            if Auth.auth().currentUser?.isEmailVerified == true {
                                step = .fullName
                            } else {
                                alertMessage = "Email is not verified yet."
                                showAlert = true
                            }
                        } catch {
                            alertMessage = "Failed to check verification: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                } label: {
                    Text("I Have Verified My Email")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color(red: 0, green: 0.387, blue: 0.5))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    
                }
                Button {
                    Task {
                        do {
                            try await authViewModel.sendVerificationEmail()
                            alertMessage = "Verification email sent again."
                            showAlert = true
                        } catch {
                            alertMessage = "Failed to resend email: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                } label: {
                    Text("Resend Verification Link")
                        .font(.headline)
                        .foregroundStyle(Color(red:0, green:0.387, blue:0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
}

#Preview {
    EmailVerificationStep(step: .constant(.fullName))
}
