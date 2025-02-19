//
//  LoginView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailErrorMessage: String = "" // Changed from optional to empty string
    @State private var passwordErrorMessage: String = "" // Changed from optional to empty string
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                // image
                Image("Image0")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 200)
                    .padding(.top, 32)
                    .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))

                Text("AutiCare")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    // email
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com", errorMessage: emailErrorMessage)
                        .textInputAutocapitalization(.never)
                        .onChange(of: email) {validateEmail()}

                    // password
                    InputView(text: $password, title: "Password", placeholder: "Enter Your Password", isSecureField: true, errorMessage: passwordErrorMessage)
                        .onChange(of: password) {validatePassword()}
                }
                .padding(.horizontal)
                .padding(.top, 12)

                // sign In
                ButtonView(title: "SIGN IN") {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.top, 24)
                .padding(.bottom, 8)

                // Sign Up
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an Account?")
                        Text("Sign Up")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.systemGray))
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func validateEmail() {
        if !isValidEmail(email) {
            emailErrorMessage = "Please enter a valid email address."
        } else {
            emailErrorMessage = ""
        }
    }

    private func validatePassword() {
        if !isValidPassword(password) {
            passwordErrorMessage = "Password must be at least 6 characters long and contain 1 uppercase, 1 lowercase, and 1 number."
        } else {
            passwordErrorMessage = ""
        }
    }
}

extension LoginView: AuthenticationProtocol {
    var formIsValid: Bool {
        return isValidEmail(email) &&
               isValidPassword(password)
    }

    private func isValidEmail(_ email: String) -> Bool {
        // Check if email is not empty and contains a '@' symbol
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        // Password should be at least 6 characters long
        // And must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number
        let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return !password.isEmpty && passwordPredicate.evaluate(with: password)
    }
}

#Preview {
    LoginView()
}

