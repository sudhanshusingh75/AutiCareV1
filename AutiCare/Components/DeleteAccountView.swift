//
//  DeleteAccountView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI

struct DeleteAccountView: View {
    @State private var password: String = ""
    @EnvironmentObject var authVM: AuthViewModel
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading,spacing: 10){
                Text("Enter Your Password To Reauthenticate and Delete Your Account")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                InputView(text: $password, title: "Current Password", placeholder: "Enter Your Password",isSecureField: true)
            }
            .padding()
            Button {
                Task{
                    await authVM.deleteAccount(password: password)
                }
            } label: {
                Text("Delete Account")
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
            
            Spacer()

        }
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DeleteAccountView()
}
