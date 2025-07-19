//
//  OtherUserSettingsView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/07/25.
//

import SwiftUI

struct OtherUserSettingsView: View {
    @ObservedObject var userManager: UserRelationshipManager
    @Environment(\.dismiss) var dismiss
    let userId: String
    var body: some View {
        Form{
            Section{
                HStack{
                    Button{
                        Task{
                            await userManager.blockUser(userId: userId)
                            dismiss()
                        }
                    }label: {
                        HStack(spacing: 20){
                            Image(systemName: "hand.raised.fill")
                                .foregroundStyle(Color.red)
                            Text("Block User")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    OtherUserSettingsView(userManager: UserRelationshipManager(), userId: "123")
}
