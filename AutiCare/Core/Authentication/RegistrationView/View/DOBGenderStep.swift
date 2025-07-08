//
//  DOBGenderStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 06/07/25.
//

import SwiftUI

struct DOBGenderStep: View {
    @ObservedObject var viewModel: RegistrationFlowViewModel
    @Binding var nextStep: RegistrationStep
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tell us About Yourself")
                    .font(.title.bold())
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading,spacing: 12) {
                            Text("Date Of Birth :")
                                .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Text(viewModel.dateOfBirthSet ? viewModel.formatedDateOfBirth : "DD/MM/YYYY")
                                .font(.system(size: 14))
                                .foregroundStyle(viewModel.dateOfBirthSet ? .black : Color(.placeholderText))
                        }
                        Spacer()
                        DatePicker("", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: 140)
                            .onChange(of: viewModel.dateOfBirth) {
                                viewModel.dateOfBirthSet = true
                                viewModel.vaildateDateOfBirth()
                            }
                    }
                    
                    Divider()
                    if !viewModel.dobErrorMessage.isEmpty {
                        Text(viewModel.dobErrorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading,spacing: 12) {
                            Text("Gender :")
                                .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Text(viewModel.selectedGender == "Select Gender"
                                 ? "Select Gender"
                                 : viewModel.selectedGender)
                            .font(.system(size: 14))
                            .foregroundStyle(viewModel.selectedGender == "Select Gender"
                                             ? Color(.placeholderText)
                                             : .black)
                        }
                        
                        Spacer()
                        Picker("Select Gender", selection: $viewModel.selectedGender) {
                            ForEach(viewModel.genders, id: \.self) { gender in
                                Text(gender).tag(gender)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: 160)
                        .onChange(of: viewModel.selectedGender) {
                            viewModel.validateGender()
                        }
                    }
                    
                    if !viewModel.genderErrorMessage.isEmpty {
                        Text(viewModel.genderErrorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Divider()
                }
                
                Button(action: {
                    if viewModel.dobErrorMessage.isEmpty && viewModel.genderErrorMessage.isEmpty {
                        nextStep = .profilePhoto
                    }
                }, label: {
                    Text("Next")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0, green: 0.387, blue: 0.5))
                        .cornerRadius(16)
                        .padding()
                })
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    DOBGenderStep(viewModel: RegistrationFlowViewModel(), nextStep: .constant(.profilePhoto))
}
