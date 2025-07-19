//
//  BlockedUsersList.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct BlockedUsersList: View {
    @StateObject private var viewModel =

    var body: some View {
        NavigationView {
            List {
                if viewModel.blockedUsers.isEmpty {
                    Text("You haven’t blocked anyone.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.blockedUsers, id: \.id) { user in
                        HStack(spacing: 16) {
                            if let imageURL = URL(string: user.profileImageURL ?? "") {
                                WebImage(url: imageURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 50, height: 50)
                            }

                            VStack(alignment: .leading) {
                                Text(user.fullName)
                                    .font(.headline)
                                Text("@\(user.userName)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button {
                                Task {
                                    await viewModel.unblockUser(userId: user.id)
                                }
                            } label: {
                                Text("Unblock")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Blocked Users")
            .onAppear {
                Task {
                    await viewModel.loadBlockedUsers()
                }
            }
        }
    }
}


#Preview {
    BlockedUsersList()
}
