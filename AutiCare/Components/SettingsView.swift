//
//  SettingRowView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showEditView = false
    var body: some View {
        Form {
            Section{
                HStack{
                    Button {
                        showEditView.toggle()
                    } label: {
                        HStack(spacing:20){
                            Image(systemName: "square.and.pencil")
                            Text("Edit Profile")
                            Spacer()
                        }
                    }
                }
                
                .fullScreenCover(isPresented: $showEditView) {
                    if let user = authVM.currentUser{
                        EditProfileView(user: user)
                    }
                }
            }
            Section{
                HStack {
                    Button(action: {
                        Task {
                            authVM.signOut()
                        }
                    }) {
                        HStack(spacing:20){
                            Image(systemName: "arrow.left.square")
                                .foregroundStyle(Color.red)
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                HStack {
                    Button(action: {
                        Task {
                            await authVM.deleteAccount()
                        }
                    }) {
                        HStack(spacing: 20){
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                            Text("Delete Account")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
