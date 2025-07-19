//
//  BlockedUsersList.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct BlockedUsersList: View {
    @StateObject private var viewModel = BlockedUsersListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
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

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullName)
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("@\(user.userName)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button(action: {
                                    Task {
                                        await viewModel.unblockUser(userId: user.id)
                                    }
                                }) {
                                    Text("Unblock")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.red.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Blocked Users")
            .navigationBarTitleDisplayMode(.inline)
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
