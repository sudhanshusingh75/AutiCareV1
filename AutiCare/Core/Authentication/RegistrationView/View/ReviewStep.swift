//
//  ReviewStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI

struct ReviewStep: View {
    @ObservedObject var viewModel: RegistrationFlowViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var agreedToTerms = false
    @State private var showAlert = false
    @State private var isLoading = false
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("Review Your Details")
                        .font(.title.bold())
                        .padding(.top)
                    
                    // Profile Image
                    HStack {
                        Spacer()
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.white, lineWidth: 4))
                                .shadow(radius: 2)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .foregroundStyle(Color.white)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                                .padding()
                        }
                        Spacer()
                    }
                    
                    // User Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Full Name: \(viewModel.fullName)")
                        Divider()
                        Text("DOB: \(viewModel.dateOfBirth.formatted(date: .abbreviated, time: .omitted))")
                        Divider()
                        Text("Gender: \(viewModel.selectedGender)")
                        Divider()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    
                    // Terms Toggle
                    Toggle("I agree to the Terms & Conditions and Privacy Policy.", isOn: $agreedToTerms)
                        .font(.footnote)
                        .padding(.vertical)

                    Button(action: {
                        if let url = URL(string: "https://policy-pages-crafted.lovable.app") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Read Terms & Conditions and Privacy Policy")
                            .underline()
                            .foregroundColor(.blue)
                            .font(.footnote)
                    }
                    
                    // Finalize Button
                    Button {
                        if agreedToTerms && !isLoading {
                            isLoading = true
                            Task {
                                await viewModel.finalizeRegistration(authViewModel: authViewModel)
                                isLoading = false
                            }
                        } else if !agreedToTerms {
                            showAlert = true
                        }
                    } label: {
                        Text(isLoading ? "Registering..." : "Register")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(Color(red: 0, green: 0.387, blue: 0.5))
                            .cornerRadius(16)
                            .padding(.top, 10)
                    }
                    .alert("Action Required", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Please agree to the Terms & Conditions and Privacy Policy before continuing.")
                    }
                    
                    Spacer(minLength: 32)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
