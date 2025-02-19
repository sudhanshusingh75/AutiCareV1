//
//  FollowingsView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 18/02/25.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI
struct FollowersView: View {
    @State private var inputText:String = ""
    @StateObject var viewModel = SearchViewModel()
    @Environment(\.dismiss) var dismiss
    let currentUserId:String = Auth.auth().currentUser?.uid ?? ""
    var filteredFollowers: [User] {
            // Filter followers based on search text
            return viewModel.followers.filter { user in
                user.id != currentUserId &&
                (user.fullName.localizedCaseInsensitiveContains(inputText) ||
                 user.userName.localizedCaseInsensitiveContains(inputText))
            }
        }
    
    var body: some View {
        NavigationStack{
            List(filteredFollowers){user in
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
                await viewModel.fetchFollowers(for: currentUserId)
            }
            .searchable(text: $inputText, placement: .toolbar, prompt: "Search Followers")
        }
    }
}

#Preview {
    FollowersView()
}
