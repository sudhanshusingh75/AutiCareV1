//
//  SettingRowView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @ObservedObject var profileVM: ProfileViewModel
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
                                .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                            Text("Edit Profile")
                                .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                            Spacer()
                        }
                    }
                }
                
                .fullScreenCover(isPresented: $showEditView) {
                    if let user = profileVM.user{
                        EditProfileView(user: user)
                    }
                }
                
                NavigationLink {
                    BlockedUsersList()
                } label: {
                    HStack(spacing: 20) {
                        Image(systemName: "person.fill.xmark")
                            .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                        Text("Blocked Users")
                            .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                        Spacer()
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
                    NavigationLink {
                        DeleteAccountView()
                    } label: {
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

