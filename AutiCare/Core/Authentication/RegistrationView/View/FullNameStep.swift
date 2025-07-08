//
//  FullNameStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 06/07/25.
//

import SwiftUI

struct FullNameStep: View {
    @ObservedObject var viewModel: RegistrationFlowViewModel
    @Binding var nextStep: RegistrationStep

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
                InputView(text: $viewModel.fullName, title: "Full Name", placeholder: "Enter your full name")
                
                Button {
                    nextStep = .dobGender
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
}
#Preview {
    FullNameStep(viewModel: RegistrationFlowViewModel(), nextStep: .constant(.dobGender))
}
