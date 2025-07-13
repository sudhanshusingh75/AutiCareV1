//
//  FullNameStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 06/07/25.
//

import SwiftUI

struct FullNameStep: View {
    @ObservedObject var viewModel: RegistrationFlowViewModel
    @Binding var nextStep: ProfileCompletionStep
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var fullNameErrorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading,spacing: 16) {
                VStack(alignment: .leading,spacing: 10){
                    Text("Enter Your Full Name")
                        .font(.title.bold())
                    Text("This name will be displayed on your Profile.")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                }
                InputView(text: $viewModel.fullName, title: "Full Name", placeholder: "Enter your full name",errorMessage: fullNameErrorMessage)
                    .onChange(of: viewModel.fullName) { _,_ in
                        validateFullName()
                    }
                
                Button {
                    validateFullName()
                    if fullNameErrorMessage.isEmpty{
                        nextStep = .dobGender
                    }
                } label: {
                    Text("Next")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color(red:0,green: 0.387,blue: 0.5))
                        .cornerRadius(16)
                        .padding()
                }
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
    private func validateFullName() {
        if viewModel.fullName.isEmpty {
            fullNameErrorMessage = "Full name cannot be empty."
        } else if !isValidFullName(viewModel.fullName) {
            fullNameErrorMessage = "Full name must contain at least two words (first and last name)."
        } else {
            fullNameErrorMessage = ""
        }
    }

    private func isValidFullName(_ fullName: String) -> Bool {
        let nameComponents = fullName.split(separator: " ")
        return nameComponents.count >= 1
    }
}
#Preview {
    FullNameStep(viewModel: RegistrationFlowViewModel(), nextStep: .constant(.dobGender))
}
