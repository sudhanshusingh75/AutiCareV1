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
            ScrollView(showsIndicators: false) {
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
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    NavigationLink {
                        ForgotPasswordView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack{
                            Spacer()
                            Text("Forgot Password?")
                                .padding(.horizontal)
                        }
                        .font(.system(size: 14))
                        .foregroundStyle(Color(.systemGray))
                    }
                    
                    // sign In
                    ButtonView(title: "SIGN IN") {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                            
                        }
                        
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(
                            title: Text("Login Error"),
                            message: Text(viewModel.alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                    
                    // Sign Up
                    NavigationLink {
                        RegistrationFlow(currentStep: .emailEntry)
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
                .onTapGesture {
                    hideKeyboard()
                }
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
}

extension LoginView: AuthenticationProtocol {
    var formIsValid: Bool {
        return isValidEmail(email)
        
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Check if email is not empty and contains a '@' symbol
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}

