//
//  FollowingsView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 20/02/25.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct FollowingsView: View {
    @State private var inputText:String = ""
    @StateObject var viewModel = SearchViewModel()
    @Environment(\.dismiss) var dismiss
    let currentUserId:String = Auth.auth().currentUser?.uid ?? ""
    var filteredFollowings: [User] {
        if inputText.isEmpty{
            return viewModel.followings.filter { $0.id != currentUserId }
        }
        return viewModel.followings.filter { user in
                user.id != currentUserId &&
                (user.fullName.localizedCaseInsensitiveContains(inputText) ||
                 user.userName.localizedCaseInsensitiveContains(inputText))
            }
        }
    var body: some View {
        NavigationStack{
            List(filteredFollowings){user in
                NavigationLink(destination: OtherUserProfileView(userId: user.id)) {
                    HStack{
                        if let url = URL(string: user.profileImageURL ?? ""){
                            WebImage(url:url)
                                .resizable()
                                .frame(width: 45,height: 45)
                                .clipShape(Circle())
                        }
                        else{
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundStyle(Color.gray)
                                .frame(width: 45,height: 45)
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text(user.fullName).font(.headline)
                            Text(user.userName).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
                
            }
            .task{
                await viewModel.fetchFollowings(for: currentUserId)
            }
            .searchable(text: $inputText, placement: .toolbar, prompt: "Search Followings")
        }
    }
}

#Preview {
    FollowingsView()
}
