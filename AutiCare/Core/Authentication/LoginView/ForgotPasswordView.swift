//
//  ForgotPasswordView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 30/04/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email: String = ""
    @State private var emailErrorMessage: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var isMailSent = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    var formIsValid: Bool {
        return isValidEmail(email)
        
    }
    var body: some View {
        NavigationStack{
        VStack {
            InputView(text: $email, title: "Enter Your Registered Email", placeholder: "name@example.com", errorMessage: emailErrorMessage)
                .textInputAutocapitalization(.never)
                .onChange(of: email) {validateEmail()}
                .padding(.horizontal)
            
            Button {
                dismiss()
            } label: {
                HStack{
                    Text("Back to Login")
                }
                .font(.system(size: 14))
                .foregroundStyle(Color(.systemGray))
                .padding(.vertical)
            }
            ButtonView(title: "Reset") {
                Task {
                    do{
                        try await viewModel.forgotPassword(email: email)
                        alertMessage = "If this email is registered with us, a password reset link has been sent."
                        isMailSent = true
                    }
                    catch{
                        alertMessage = error.localizedDescription
                        isMailSent = true
                    }
                    showAlert = true
                }
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK"),action: {
                    if isMailSent{
                        dismiss()
                    }
                }))
            }
            Spacer()
        }
        .padding(.vertical)
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
    }
}
    private func validateEmail() {
        if !isValidEmail(email) {
            emailErrorMessage = "Please enter a valid email address."
        } else {
            emailErrorMessage = ""
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        // Check if email is not empty and contains a '@' symbol
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }
}

#Preview {
    ForgotPasswordView()
}
